public class ContactTriggerHelper {

    public static void afterInsert(Map<Id,Contact> newMap) {
        populateHighestContactByTitle(newMap.values());
        createFollowupActivities(newMap.values());
        // publish insert event
        EventsHelper.publishEvent((List<SObject>)newMap.values(), EventsHelper.DMLContext.INSERT_C);
    }

    public static void afterUpdate(Map<Id,Contact> oldMap, Map<Id,Contact> newMap) {
        populateHighestContactByTitle(newMap.values());
        // publish update event
        EventsHelper.publishEvent((List<SObject>)newMap.values(), EventsHelper.DMLContext.UPDATE_C);
    }

    public static void createFollowupActivities(List<Contact> cons) {
        createFollowupTasks(cons);
        createIntroCallEvents(cons);
    }

    public static void createFollowupTasks(List<Contact> cons) {
        List<Task> tasks = new List<Task>();
        for(Contact con:cons) {
            tasks.add(new Task(
                Subject = 'Get more information on ' + con.Name__c,
                WhoID = con.Id,
                WhatID = con.AccountId,
                ActivityDate = Date.today().addDays(7)
            ));
        }
        if(tasks != null && tasks.isEmpty()) {
            insert tasks;
        }
    }

    public static void createIntroCallEvents(List<Contact> cons) {
        List<Event> events = new List<Event>();
        for(Contact con:cons) {
            events.add(new Event(
                Subject = 'introcall',
                WhoID = con.Id,
                WhatID = con.AccountId,
                ActivityDateTime = DateTime.now().addDays(30)
            ));
        }
        if(events != null && events.isEmpty()) {
            insert events;
        }
    }

    // not exactly necessary, but cool
    public static void populateHighestContactByTitle(List<Contact> cons) {

        // used for account query
        Set<Id> accIds = new Set<Id>();
        // populated with newly updated accounts
        List<Account> accs = new List<Account>();

        // get account id's
        for(Contact con:cons) {
            if(String.isNotBlank(con.AccountId)) {
                accIds.add(con.AccountId);
            }
        }

        // temp list of comparable objects
        List<ContactTitleCompare> tempCons;

        // we need all of the contacts from every account to compare, so we do an inner join
        for(Account acc:[
            SELECT Id, Name, Highest_Contact_by_Title__c, 
                (SELECT Id, Name, Title FROM Contacts WHERE Title != null ORDER BY LastName, FirstName)
            FROM Account
            WHERE Id IN:accIds
        ]) {
            if(acc.Contacts != null && !acc.Contacts.isEmpty()) {
                // we create a new list every execution
                tempCons = new List<ContactTitleCompare>();
                for(Contact con:acc.Contacts) {
                    tempCons.add(new ContactTitleCompare(con));
                }
                tempCons.sort();
                if(acc.Highest_Contact_by_Title__c == null || acc.Highest_Contact_by_Title__c != tempCons[0].con.Id) {
                    acc.Highest_Contact_by_Title__c = tempCons[0].con.Id;
                    accs.add(acc);
                }
            }
        }

        // if there are accounts to update, update them
        if(accs != null && !accs.isEmpty()) {
            update accs;
        }
    }
}