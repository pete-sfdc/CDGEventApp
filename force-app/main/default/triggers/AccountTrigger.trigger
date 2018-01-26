trigger AccountTrigger on account (after insert) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            AccountTriggerHelper.afterInsert(Trigger.newMap);
        }
    }
}