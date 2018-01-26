trigger ContactTrigger on Contact (before insert) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            ContactTriggerHelper.afterInsert(Trigger.newMap);
        } else if(Trigger.isUpdate) {
            ContactTriggerHelper.afterUpdate(Trigger.oldMap, Trigger.newMap);
        }
    }
}