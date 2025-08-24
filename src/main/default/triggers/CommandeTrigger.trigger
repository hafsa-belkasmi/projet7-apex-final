trigger CommandeTrigger on Commande__c (
    before insert,
    after insert,
    after update
) {
    if (Trigger.isBefore && Trigger.isInsert) {
        CommandeTriggerHandler.beforeInsert(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        CommandeTriggerHandler.afterInsert(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        CommandeTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
    }
}
