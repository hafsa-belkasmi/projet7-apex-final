/**
 * Trigger CommandeTrigger sur l’objet Commande__c.
 *
 * Événements gérés :
 *  - BEFORE INSERT  → Vérifie les règles métier (ex. un seul brouillon par compte)
 *  - AFTER INSERT   → Recalcule le montant des commandes insérées
 *  - AFTER UPDATE   → Recalcule le montant si la quantité change ou si le statut redevient "Brouillon"
 *
 * Toute la logique métier est déléguée à la classe CommandeTriggerHandler.
 */
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
