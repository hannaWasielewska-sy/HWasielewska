public class ContactTriggerHandler {
    
    public static void handleBeforeInsertUpdate(List<Contact> newContacts, Map<Id, Contact> oldContactsMap) {
        for (Contact newContact : newContacts) {
            Contact oldContact = oldContactsMap != null ? oldContactsMap.get(newContact.Id) : null;
            
            if (oldContact != null && oldContact.AccountId != null && newContact.AccountId == null) {
                newContact.addError('Unable to remove account field value');
            }
            
            if (newContact.Email == null && newContact.Phone == null) {
                newContact.addError('Please provide phone or email value');
            }
        }
    }
    
    public static void handleAfterInsert(List<Contact> newContacts) {
        List<Contact_History__c> historyRecords = new List<Contact_History__c>();
        
        for (Contact newContact : newContacts) {
            Contact_History__c history = new Contact_History__c();
            history.Contact__c = newContact.Id;
            history.Contact_History_Name__c = 'Insert ' + getContactName(newContact) + ' ' + newContact.Id;
            history.Action__c = 'Insert';
            history.Timestamp__c = System.now();
            
            historyRecords.add(history);
        }
        
        if (!historyRecords.isEmpty()) {
            insert historyRecords;
        }
    }
    
    public static void handleAfterUpdate(List<Contact> newContacts, Map<Id, Contact> oldContactsMap) {
        List<Contact_History__c> historyRecords = new List<Contact_History__c>();
        Set<String> fieldsToTrack = new Set<String>{'FirstName', 'LastName', 'Email', 'Phone', 'AccountId'};
        
        for (Contact newContact : newContacts) {
            Contact oldContact = oldContactsMap.get(newContact.Id);
            

            for (String fieldName : fieldsToTrack) {
                Object oldValue = oldContact.get(fieldName);
                Object newValue = newContact.get(fieldName);
                
                if (oldValue != newValue) {
                    Contact_History__c history = new Contact_History__c();
                    history.Contact__c = newContact.Id;
                    history.Contact_History_Name__c = getContactName(newContact) + ' ' + newContact.Id + ' Update';
                    history.Action__c = 'Update';
                    history.Timestamp__c = System.now();
                    history.New_Value__c = String.valueOf(newValue);
                    history.Old_Value__c = String.valueOf(oldValue);
                    history.Edited_Field_Name__c = fieldName;
                    
                    historyRecords.add(history);
                }
            }
        }
        
        if (!historyRecords.isEmpty()) {
            insert historyRecords;
        }
    }
    
    public static void handleAfterDelete(List<Contact> oldContacts) {
        List<Contact_History__c> historyRecords = new List<Contact_History__c>();
        
        for (Contact oldContact : oldContacts) {
            Contact_History__c history = new Contact_History__c();
            
            history.Contact_History_Name__c = 'Delete ' + getContactName(oldContact) + ' ' + oldContact.Id;
            history.Action__c = 'Delete';
            history.Timestamp__c = System.now();
            
            historyRecords.add(history);
        }
        
        if (!historyRecords.isEmpty()) {
            insert historyRecords;
        }
    }
    
    // pomocna metoda
    private static String getContactName(Contact contact) {
        String firstName = contact.FirstName != null ? contact.FirstName : '';
        String lastName = contact.LastName != null ? contact.LastName : '';
        return (firstName + ' ' + lastName).trim();
    }
} 