trigger PetTrigger on Pet__c (after update) {
    PetHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
} 