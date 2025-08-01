public class ContactCreator {

    public static void createContacts(Integer numberOfContacts, String contactName, String accountName) {
        Account acc = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];
        List<Contact> contactsToInsert = new List<Contact>();
        for (Integer i = 1; i <= numberOfContacts; i++) {
            contactsToInsert.add(new Contact(
                LastName = contactName + i,
                AccountId = acc.Id
            ));
        }
        insert contactsToInsert;
    }

    public static String deleteContact(Id contactId) {
        try {
            Contact c = [SELECT Id FROM Contact WHERE Id = :contactId LIMIT 1];
            delete c;
            return 'Success';
        } catch (QueryException e) {
            return 'No contact found';
        }
    }

    public static Integer getNumberOfContacts(String accountName) {
        Account acc = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];
        return [SELECT COUNT() FROM Contact WHERE AccountId = :acc.Id];
    }

    public static Set<Id> getContactByLastName(String lastName) {
        List<Contact> contacts = [SELECT Id, AccountId, FirstName, LastName, Email, Phone FROM Contact WHERE LastName = :lastName];
        Set<Id> contactIds = new Set<Id>();
        for (Contact c : contacts) {
            contactIds.add(c.Id);
        }
        return contactIds;
    }
}
