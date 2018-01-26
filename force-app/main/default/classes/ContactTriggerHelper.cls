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
            if(String.isNotBlank(con.AccountId)) {
                accIds.add(con.AccountId);
            }
        }

        List<ContactTitleCompare> tempCons = new List<ContactTitleCompare>();

        for(Account acc:[
            SELECT Id, Name, Highest_Contact_by_Title__c, (SELECT Id, Name, Title FROM Contacts ORDER BY LastName, FirstName)
            FROM Account
            WHERE Id IN:accIds
        ]) {
            if(acc.Contacts != null && !acc.Contacts.isEmpty()) {
                System.debug('Account Name: ' + acc.Name);
                System.debug('Number of Contacts: ' + acc.Contacts.size());
                tempCons = new List<ContactTitleCompare>();
                for(Contact con:acc.Contacts) {
                    tempCons.add(new ContactTitleCompare(con));
                }
                tempCons.sort();
                if(acc.Highest_Contact_by_Title__c == null || acc.Highest_Contact_by_Title__c != tempCons[0].con.Id) {
                    System.debug('Highest: ' + tempCons[0].con.Id + ' ' + tempCons[0].con.Name);
                    acc.Highest_Contact_by_Title__c = tempCons[0].con.Id;
                    accs.add(acc);
                }
            }
        }

        if(accs != null && !accs.isEmpty()) {
            System.debug('Number of accs updated ' + accs.size());
            update accs;
        }
    }
}