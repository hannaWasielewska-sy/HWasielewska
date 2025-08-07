@isTest
public class PetHandlerTest {
    @isTest
    static void testHandleAfterUpdate() {
        Contact c1 = new Contact(FirstName='A', LastName='B');
        insert c1;
        Pet__c pet = new Pet__c(Name='Test', Type__c='Dog', For_Adoption__c=true);
        insert pet;
        pet.Owner__c = c1.Id;
        update pet;
    }
} 