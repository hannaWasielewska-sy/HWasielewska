public class PetHandler {
    public static void handleAfterUpdate(List<Pet__c> newList, Map<Id, Pet__c> oldMap) {
        for (Pet__c pet : newList) {
            Pet__c oldPet = oldMap.get(pet.Id);
            if (pet.Owner__c != oldPet.Owner__c && pet.Owner__c != null) {
                System.debug('Owner changed for Pet: ' + pet.Id);
            }
        }
    }
} 