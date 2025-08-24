/**
 * Trigger CommandeManagementTrigger sur l’objet Commande__c.
 *
 * Événements gérés :
 *  - BEFORE INSERT :
 *      → Valide automatiquement la commande si le compte est de type "Client"
 *  - BEFORE UPDATE :
 *      → Valide automatiquement la commande si applicable
 *      → Met à jour les informations d’expédition si un transporteur est renseigné
 */
trigger CommandeManagementTrigger on Commande__c (before insert, before update) {
    for (Commande__c ord : Trigger.new) {
        Account acc = [SELECT Id, Type FROM Account WHERE Id = :ord.Compte__c LIMIT 1];
        OrderService.validateOrder(ord, acc);
    }

    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Commande__c ord : Trigger.new) {
            if (ord.Transporter__c != null) {
                Transporter__c transp = [
                    SELECT Id, Address__c, Cost__c
                    FROM Transporter__c
                    WHERE Id = :ord.Transporter__c
                    LIMIT 1
                ];
                OrderService.updateShippingInfo(ord, transp);
            }
        }
    }
}