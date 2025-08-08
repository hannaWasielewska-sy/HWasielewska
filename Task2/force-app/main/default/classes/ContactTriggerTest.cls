@isTest
public class ContactTriggerTest {
    
    @TestSetup
    static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }
    
    @isTest
    static void testContactInsertSuccess() {
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
        
        // czy kontakt utworzony?
        List<Contact> createdContacts = [SELECT Id, FirstName, LastName, Email, AccountId FROM Contact WHERE Id = :testContact.Id];
        Assert.areEqual(1, createdContacts.size(), 'Contact should be created successfully');
        
        // czy historia utworzona?
        List<Contact_History__c> historyRecords = [SELECT Id, Contact__c, Contact_History_Name__c, Action__c, Timestamp__c 
                                                 FROM Contact_History__c WHERE Contact__c = :testContact.Id];
        Assert.areEqual(1, historyRecords.size(), 'Contact History record should be created for insert');
        Assert.areEqual('Insert', historyRecords[0].Action__c, 'Action should be Insert');
    }
    
    @isTest
    static void testContactInsertWithPhoneOnly() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Contact testContact = new Contact(
            FirstName = 'Jane',
            LastName = 'Smith',
            Phone = '1234567890',
            AccountId = testAccount.Id
        );
        
        Test.startTest();
        insert testContact;
        Test.stopTest();
        
        // czy kontakt utworzony?
        List<Contact> createdContacts = [SELECT Id, FirstName, LastName, Phone, AccountId FROM Contact WHERE Id = :testContact.Id];
        Assert.areEqual(1, createdContacts.size(), 'Contact should be created successfully with phone only');
    }
    
    @isTest
    static void testContactInsertWithoutEmailAndPhone() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Contact testContact = new Contact(
            FirstName = 'Bob',
            LastName = 'Johnson',
            AccountId = testAccount.Id
        );
        
        Test.startTest();
        try {
            insert testContact;
            System.assert(false, 'Should have thrown an error for contact without email and phone');
        } catch (DmlException e) {
            Assert.isTrue(e.getMessage().contains('Please provide phone or email value'), 
                'Error message should indicate phone or email is required');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testContactUpdateSuccess() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@test.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        testContact.FirstName = 'Jane';
        testContact.Email = 'jane.doe@test.com';
        
        Test.startTest();
        update testContact;
        Test.stopTest();
        
        List<Contact_History__c> historyRecords = [SELECT Id, Contact__c, Contact_History_Name__c, Action__c, 
                                                 New_Value__c, Old_Value__c, Edited_Field_Name__c
                                                 FROM Contact_History__c WHERE Contact__c = :testContact.Id];
        Assert.areEqual(2, historyRecords.size(), 'Should create history records for each changed field');
        
        for (Contact_History__c history : historyRecords) {
            Assert.areEqual('Update', history.Action__c, 'Action should be Update');
            if (history.Edited_Field_Name__c == 'FirstName') {
                Assert.areEqual('Jane', history.New_Value__c, 'New FirstName should be Jane');
                Assert.areEqual('John', history.Old_Value__c, 'Old FirstName should be John');
            } else if (history.Edited_Field_Name__c == 'Email') {
                Assert.areEqual('jane.doe@test.com', history.New_Value__c, 'New Email should be jane.doe@test.com');
                Assert.areEqual('john.doe@test.com', history.Old_Value__c, 'Old Email should be john.doe@test.com');
            }
        }
    }
    
    @isTest
    static void testContactUpdateRemoveAccountId() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@test.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        testContact.AccountId = null;
        
        Test.startTest();
        try {
            update testContact;
            System.assert(false, 'Should have thrown an error for removing account');
        } catch (DmlException e) {
            Assert.isTrue(e.getMessage().contains('Unable to remove account field value'), 
                'Error message should indicate account cannot be removed');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testContactDelete() {
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
    }
    
    @isTest
    static void testBulkOperations() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        // Test bulk insert
        List<Contact> contactsToInsert = new List<Contact>();
        for (Integer i = 1; i <= 200; i++) {
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
        Assert.areEqual(200, createdContacts.size(), 'All 200 contacts should be created');
        
        List<Contact_History__c> historyRecords = [SELECT Id FROM Contact_History__c WHERE Action__c = 'Insert'];
        Assert.areEqual(200, historyRecords.size(), 'Contact History records should be created for all contacts');
    }
} 