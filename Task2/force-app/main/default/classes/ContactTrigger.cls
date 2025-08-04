trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete) {
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            ContactTriggerHandler.handleBeforeInsertUpdate(Trigger.new, Trigger.oldMap);
        }
    }
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            ContactTriggerHandler.handleAfterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            ContactTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        } else if (Trigger.isDelete) {
            ContactTriggerHandler.handleAfterDelete(Trigger.old);
        }
    }
} 