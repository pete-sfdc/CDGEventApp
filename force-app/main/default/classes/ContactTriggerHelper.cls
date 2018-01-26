public class ContactTriggerHelper {

    public static void afterInsert(Map<Id,Contact> newMap) {
        populateHighestContactByTitle(newMap.values());
    }

    public static void afterUpdate(Map<Id,Contact> oldMap, Map<Id,Contact> newMap) {
        populateHighestContactByTitle(newMap.values());
    }

    public static void populateHighestContactByTitle(List<Contact> cons) {

        Set<Id> accIds = new Set<Id>();
        List<Account> accs = new List<Account>();

        for(Contact con:cons) {
            // A Contact doesn't always have to have an Account
            if(String.isNotBlank(con.AccountId)) {
                accIds.add(con.AccountId);
            }
        }

        List<ContactTitleCompare> tempCons = new List<ContactTitleCompare>();

        for(Account acc:[
            SELECT Id, Highest_Contact_by_Title__c, (SELECT Id, Name, Title FROM Contacts)
            FROM Account
            WHERE Id IN:accIds
        ]) {
            if(acc.Contacts != null && !acc.Contacts.isEmpty()) {
                tempCons = new List<ContactTitleCompare>();
                for(Contact con:acc.Contacts) {
                    tempCons.add(new ContactTitleCompare(con));
                }
                tempCons.sort();
                if(acc.Highest_Contact_by_Title__c != tempCons[0].con.Id) {
                    acc.Highest_Contact_by_Title__c = tempCons[0].con.Id;
                    accs.add(acc);
                }
            }
        }

        if(accs != null && !accs.isEmpty()) {
            update accs;
        }
    }
}