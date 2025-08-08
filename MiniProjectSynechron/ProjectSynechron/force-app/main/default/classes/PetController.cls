public with sharing class PetController {
    @AuraEnabled(cacheable=true)
    public static List<Pet__c> getPets(String filter) {
        String query = 'SELECT Id, Name, Type__c, Birthday__c, Color__c, Picture__c, For_Adoption__c, Description__c, Owner__c, Owner__r.Name FROM Pet__c';
        if (filter == 'Adopted') {
            query += ' WHERE For_Adoption__c = FALSE AND Owner__c != NULL';
        } else if (filter == 'ForAdoption') {
            query += ' WHERE For_Adoption__c = TRUE';
        }
        return Database.query(query);
    }

    @AuraEnabled
    public static void adoptPet(String petId, String firstName, String lastName, String phone, String email, String street, String postalCode, String city) {
        Contact newContact = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Phone = phone,
            Email = email,
            MailingStreet = street,
            MailingPostalCode = postalCode,
            MailingCity = city
        );
        insert newContact;

        Pet__c pet = [
            SELECT Id, For_Adoption__c, Owner__c
            FROM Pet__c
            WHERE Id = :petId
            LIMIT 1
        ];

        pet.Owner__c = newContact.Id;
        pet.For_Adoption__c = false;
        update pet;
    }

    @AuraEnabled
    public static void adoptPetWithContact(String petId, String contactId) {
        Pet__c pet = [
            SELECT Id, For_Adoption__c, Owner__c
            FROM Pet__c
            WHERE Id = :petId
            LIMIT 1
        ];

        pet.Owner__c = contactId;
        pet.For_Adoption__c = false;
        update pet;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> searchContacts(String searchTerm) {
        String q = '%' + searchTerm + '%';
        return [
            SELECT Id, FirstName, LastName, Email
            FROM Contact
            WHERE FirstName LIKE :q OR LastName LIKE :q OR Email LIKE :q
            LIMIT 10
        ];
    }
}