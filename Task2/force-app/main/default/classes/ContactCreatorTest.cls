@isTest
public class ContactCreatorTest {
    
    @TestSetup
    static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }
    
    @isTest
    static void testCreateContacts() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Test.startTest();
        ContactCreator.createContacts(3, 'TestContact', 'Test Account');
        Test.stopTest();
        
        // Verify contacts were created
        List<Contact> createdContacts = [SELECT Id, LastName, AccountId FROM Contact WHERE AccountId = :testAccount.Id];
        System.assertEquals(3, createdContacts.size(), 'Should have created 3 contacts');
        
        // Verify contact names
        for (Integer i = 0; i < createdContacts.size(); i++) {
            System.assertEquals('TestContact' + (i + 1), createdContacts[i].LastName, 
                'Contact last name should be TestContact' + (i + 1));
        }
    }
    
    @isTest
    static void testDeleteContact() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Contact testContact = new Contact(
            LastName = 'Test Contact',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Test.startTest();
        String result = ContactCreator.deleteContact(testContact.Id);
        Test.stopTest();
        
        System.assertEquals('Success', result, 'Should return Success for valid contact deletion');
        
        List<Contact> remainingContacts = [SELECT Id FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals(0, remainingContacts.size(), 'Contact should be deleted');
    }
    
    @isTest
    static void testDeleteContactNotFound() {
        // nie ma takiego id
        Id fakeId = '003000000000000';
        
        Test.startTest();
        String result = ContactCreator.deleteContact(fakeId);
        Test.stopTest();
        
        // error
        System.assertEquals('No contact found', result, 'Should return error message for non-existent contact');
    }
    
    @isTest
    static void testGetNumberOfContacts() {

        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        List<Contact> contactsToInsert = new List<Contact>();
        
        for (Integer i = 1; i <= 5; i++) {
            contactsToInsert.add(new Contact(
                LastName = 'Contact' + i,
                AccountId = testAccount.Id
            ));
        }
        insert contactsToInsert;
        
        Test.startTest();
        Integer count = ContactCreator.getNumberOfContacts('Test Account');
        Test.stopTest();
        
        System.assertEquals(5, count, 'Should return correct number of contacts for the account');
    }
    
    @isTest
    static void testGetContactByLastName() {
        // Create test contacts
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        List<Contact> contactsToInsert = new List<Contact>();
        
        for (Integer i = 1; i <= 3; i++) {
            contactsToInsert.add(new Contact(
                LastName = 'Smith',
                FirstName = 'John' + i,
                AccountId = testAccount.Id
            ));
        }
        insert contactsToInsert;
        
        Test.startTest();
        Set<Id> contactIds = ContactCreator.getContactByLastName('Smith');
        Test.stopTest();
        
        System.assertEquals(3, contactIds.size(), 'Should return 3 contact IDs for lastName Smith');
        
        for (Id contactId : contactIds) {
            System.assertNotEquals(null, contactId, 'Contact ID should not be null');
        }
    }
    
    @isTest
    static void testGetContactByLastNameNoResults() {
        Test.startTest();
        Set<Id> contactIds = ContactCreator.getContactByLastName('NonExistent');
        Test.stopTest();
        
        System.assertEquals(0, contactIds.size(), 'Should return empty set for non-existent lastName');
    }
} 