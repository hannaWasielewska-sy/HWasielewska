@isTest
public class PetControllerTest {
    @testSetup
    static void setup() {
        // Create a Contact
        Contact c = new Contact(FirstName='Test', LastName='Owner', Email='testowner@example.com');
        insert c;
        // Create Pets
        Pet__c pet1 = new Pet__c(Name='Doggo', Type__c='Dog', For_Adoption__c=true);
        Pet__c pet2 = new Pet__c(Name='Kitty', Type__c='Cat', For_Adoption__c=false, Owner__c=c.Id);
        insert new List<Pet__c>{pet1, pet2};
    }

    @isTest
    static void testGetPets() {
        Test.startTest();
        List<Pet__c> allPets = PetController.getPets('All');
        List<Pet__c> adoptedPets = PetController.getPets('Adopted');
        List<Pet__c> forAdoptionPets = PetController.getPets('ForAdoption');
        Test.stopTest();
        System.assert(!allPets.isEmpty(), 'Should return pets');
        System.assert(!adoptedPets.isEmpty(), 'Should return adopted pets');
        System.assert(!forAdoptionPets.isEmpty(), 'Should return pets for adoption');
    }

    @isTest
    static void testAdoptPet() {
        Pet__c pet = [SELECT Id FROM Pet__c WHERE For_Adoption__c = true LIMIT 1];
        Test.startTest();
        PetController.adoptPet(pet.Id, 'John', 'Doe', '123456789', 'john@example.com', 'Street 1', '00-000', 'City');
        Test.stopTest();
        Pet__c updatedPet = [SELECT Owner__c, For_Adoption__c FROM Pet__c WHERE Id = :pet.Id];
        System.assertNotEquals(null, updatedPet.Owner__c, 'Owner should be set');
        System.assertEquals(false, updatedPet.For_Adoption__c, 'For Adoption should be false');
    }

    @isTest
    static void testAdoptPetWithContact() {
        Pet__c pet = [SELECT Id FROM Pet__c WHERE For_Adoption__c = true LIMIT 1];
        Contact c = new Contact(FirstName='Jane', LastName='Smith');
        insert c;
        Test.startTest();
        PetController.adoptPetWithContact(pet.Id, c.Id);
        Test.stopTest();
        Pet__c updatedPet = [SELECT Owner__c, For_Adoption__c FROM Pet__c WHERE Id = :pet.Id];
        System.assertEquals(c.Id, updatedPet.Owner__c, 'Owner should be set to selected contact');
        System.assertEquals(false, updatedPet.For_Adoption__c, 'For Adoption should be false');
    }

    @isTest
    static void testSearchContacts() {
        Test.startTest();
        List<Contact> results = PetController.searchContacts('Test');
        Test.stopTest();
        System.assert(!results.isEmpty(), 'Should find contacts');
    }
} 