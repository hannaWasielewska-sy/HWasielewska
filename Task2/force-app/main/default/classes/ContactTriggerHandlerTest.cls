@isTest
public class ContactTriggerHandlerTest {
    
    @TestSetup
    static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }
    
    @isTest
    static void testHandleBeforeInsertUpdate() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Contact validContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@test.com',
            AccountId = testAccount.Id
        );
        
        Test.startTest();
        insert validContact;
        Test.stopTest();
        
        // czy kontakt stworzony poprawnie?
        List<Contact> createdContacts = [SELECT Id FROM Contact WHERE Id = :validContact.Id];
        System.assertEquals(1, createdContacts.size(), 'Valid contact should be created');
    }
    
    @isTest
    static void testHandleBeforeInsertUpdateWithoutEmailAndPhone() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        // bez maila i numeru telefonu
        Contact invalidContact = new Contact(
            FirstName = 'Bob',
            LastName = 'Johnson',
            AccountId = testAccount.Id
        );
        
        Test.startTest();
        Exception e;
        try {
            insert invalidContact;
        } catch (Exception exc) {
            e = exc;
        }
        Assert.isNotNull(e, 'Exception should be thrown');
        Assert.isTrue(e.getMessage().contains('Please provide phone or email value'), 
            'Error message should indicate phone or email is required');
        Test.stopTest();
    }
    
    @isTest
    static void testHandleBeforeInsertUpdateRemoveAccountId() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        // utworz kontakt z kontem
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@test.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        // sproboj usunac konto
        testContact.AccountId = null;
        
        Test.startTest();
        Exception e;
        try {
            update testContact;
        } catch (Exception exc) {
            e = exc;
        }
        Assert.isNotNull(e, 'Exception should be thrown');
        Assert.isTrue(e.getMessage().contains('Unable to remove account field value'), 
            'Error message should indicate account cannot be removed');
        Test.stopTest();
    }
    
    @isTest
    static void testHandleAfterInsert() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@test.com',
            AccountId = testAccount.Id
        );
        
        Test.startTest();
        insert testContact;
        Test.stopTest();
        
        
        List<Contact_History__c> historyRecords = [SELECT Id, Contact__c, Contact_History_Name__c, Action__c, Timestamp__c 
                                                 FROM Contact_History__c WHERE Contact__c = :testContact.Id];
        Assert.areEqual(1, historyRecords.size(), 'Contact History record should be created for insert');
        Assert.areEqual('Insert', historyRecords[0].Action__c, 'Action should be Insert');
        Assert.areEqual(testContact.Id, historyRecords[0].Contact__c, 'Contact should be set correctly');
        Assert.isTrue(historyRecords[0].Contact_History_Name__c.startsWith('Insert'), 
            'Contact History Name should start with Insert');
    }
    
    @isTest
    static void testHandleAfterUpdate() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@test.com',
            Phone = '1234567890',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        
        testContact.FirstName = 'Jane';
        testContact.Email = 'jane.doe@test.com';
        testContact.Phone = '0987654321';
        
        Test.startTest();
        update testContact;
        Test.stopTest();
        
        
        List<Contact_History__c> historyRecords = [SELECT Id, Contact__c, Contact_History_Name__c, Action__c, 
                                                 New_Value__c, Old_Value__c, Edited_Field_Name__c
                                                 FROM Contact_History__c WHERE Contact__c = :testContact.Id AND Action__c = 'Update'];
        Assert.areEqual(3, historyRecords.size(), 'Should create history records for each changed field');
        
    
        for (Contact_History__c history : historyRecords) {
            Assert.areEqual('Update', history.Action__c, 'Action should be Update');
            Assert.areEqual(testContact.Id, history.Contact__c, 'Contact should be set correctly');
            
            if (history.Edited_Field_Name__c == 'FirstName') {
                Assert.areEqual('Jane', history.New_Value__c, 'New FirstName should be Jane');
                Assert.areEqual('John', history.Old_Value__c, 'Old FirstName should be John');
            } else if (history.Edited_Field_Name__c == 'Email') {
                Assert.areEqual('jane.doe@test.com', history.New_Value__c, 'New Email should be jane.doe@test.com');
                Assert.areEqual('john.doe@test.com', history.Old_Value__c, 'Old Email should be john.doe@test.com');
            } else if (history.Edited_Field_Name__c == 'Phone') {
                Assert.areEqual('0987654321', history.New_Value__c, 'New Phone should be 0987654321');
                Assert.areEqual('1234567890', history.Old_Value__c, 'Old Phone should be 1234567890');
            }
        }
    }
    
    @isTest
    static void testHandleAfterUpdateNoChanges() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@test.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        testContact.Description = 'Updated description';
        
        Test.startTest();
        update testContact;
        Test.stopTest();
        
        List<Contact_History__c> historyRecords = [SELECT Id FROM Contact_History__c WHERE Contact__c = :testContact.Id AND Action__c = 'Update'];
        Assert.areEqual(0, historyRecords.size(), 'No history records should be created for untracked field changes');
    }
    
    @isTest
    static void testHandleAfterDelete() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@test.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Test.startTest();
        delete testContact;
        Test.stopTest();
        
    
        List<Contact_History__c> historyRecords = [SELECT Id, Contact_History_Name__c, Action__c, Timestamp__c 
                                                 FROM Contact_History__c WHERE Contact_History_Name__c LIKE 'Delete%'];
        Assert.areEqual(1, historyRecords.size(), 'Contact History record should be created for delete');
        Assert.areEqual('Delete', historyRecords[0].Action__c, 'Action should be Delete');
        Assert.isTrue(historyRecords[0].Contact_History_Name__c.startsWith('Delete'), 
            'Contact History Name should start with Delete');
        
    }
    
    @isTest
    static void testGetContactName() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Contact contact1 = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@test.com',
            AccountId = testAccount.Id
        );
        
        Contact contact2 = new Contact(
            LastName = 'Smith',
            Email = 'smith@test.com',
            AccountId = testAccount.Id
        );
        
        Contact contact3 = new Contact(
            FirstName = 'Jane',
            Email = 'jane@test.com',
            AccountId = testAccount.Id
        );
        
        insert new List<Contact>{contact1, contact2, contact3};
        
        List<Contact_History__c> historyRecords = [SELECT Contact_History_Name__c FROM Contact_History__c WHERE Action__c = 'Insert'];
        Assert.areEqual(3, historyRecords.size(), 'Should have 3 history records');
        
        for (Contact_History__c history : historyRecords) {
            Assert.isTrue(history.Contact_History_Name__c.contains('Insert'), 
                'History name should contain Insert');
        }
    }
    
    @isTest
    static void testBulkOperations() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        List<Contact> contactsToInsert = new List<Contact>();
        for (Integer i = 1; i <= 100; i++) {
            contactsToInsert.add(new Contact(
                FirstName = 'Contact' + i,
                LastName = 'Test',
                Email = 'contact' + i + '@test.com',
                AccountId = testAccount.Id
            ));
        }
        
        Test.startTest();
        insert contactsToInsert;
        Test.stopTest();
        
        List<Contact> createdContacts = [SELECT Id FROM Contact WHERE AccountId = :testAccount.Id];
        Assert.areEqual(100, createdContacts.size(), 'All 100 contacts should be created');
        
        List<Contact_History__c> historyRecords = [SELECT Id FROM Contact_History__c WHERE Action__c = 'Insert'];
        Assert.areEqual(100, historyRecords.size(), 'Contact History records should be created for all contacts');
    }
} 