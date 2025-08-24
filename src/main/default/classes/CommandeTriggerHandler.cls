public class CommandeTriggerHandler {

    // Avant insertion : interdiction de plusieurs commandes brouillon pour un même compte
    public static void beforeInsert(List<Commande__c> commandes) {
        Set<Id> compteIds = new Set<Id>();
        System.debug('Début beforeInsert');

        // Étape 1 : Extraire les comptes des commandes en brouillon
        for (Commande__c cmd : commandes) {
            if (cmd.Statut__c == 'Brouillon' && cmd.Compte__c != null) {
                compteIds.add(cmd.Compte__c);
            }
        }
        System.debug('Comptes concernés : ' + compteIds);

        // Étape 2 : Requête des brouillons existants déjà enregistrés en base
        Map<Id, Integer> brouillonsExistants = new Map<Id, Integer>();
        if (!compteIds.isEmpty()) {
            for (AggregateResult ar : [
                SELECT Compte__c compteId, COUNT(Id) total
                FROM Commande__c
                WHERE Statut__c = 'Brouillon' AND Compte__c IN :compteIds
                GROUP BY Compte__c
            ]) {
                Id compteId = (Id) ar.get('compteId');
                Integer total = (Integer) ar.get('total');
                brouillonsExistants.put(compteId, total);
                System.debug(' Brouillons en base pour ' + compteId + ' : ' + total);
            }
        }

        // Étape 3 : Vérifie aussi les brouillons de cette même transaction (en mémoire)
        Map<Id, Integer> brouillonsDansTransaction = new Map<Id, Integer>();

        for (Commande__c cmd : commandes) {
            if (cmd.Statut__c == 'Brouillon' && cmd.Compte__c != null) {
                Id compteId = cmd.Compte__c;

                Integer dejaEnBase = brouillonsExistants.get(compteId) != null ? brouillonsExistants.get(compteId) : 0;
                Integer enMemoire = brouillonsDansTransaction.get(compteId) != null ? brouillonsDansTransaction.get(compteId) : 0;

                System.debug('🔍 Vérification commande : compte=' + compteId + ', en base=' + dejaEnBase + ', en mémoire=' + enMemoire);

                if (dejaEnBase + enMemoire >= 1) {
                    System.debug(' Erreur : commande refusée (déjà un brouillon existant)');
                    cmd.addError('Un client ne peut avoir qu\'une seule commande en brouillon.');
                } else {
                    brouillonsDansTransaction.put(compteId, enMemoire + 1);
                    System.debug(' Commande acceptée pour ce compte');
                }
            }
        }

        System.debug(' Fin beforeInsert');
    }

    // Après insertion : recalcul du montant pour les commandes en brouillon
    public static void afterInsert(List<Commande__c> commandes) {
        List<Id> commandeIds = new List<Id>();
        System.debug(' afterInsert déclenché');

        for (Commande__c cmd : commandes) {
            if (cmd.Statut__c == 'Brouillon') {
                commandeIds.add(cmd.Id);
            }
        }

        System.debug('Commandes à recalculer : ' + commandeIds);

        if (!commandeIds.isEmpty()) {
            for (Id cmdId : commandeIds) {
                System.debug('↩️ Recalcul du montant pour la commande : ' + cmdId);
                CalculMontant.calculerMontant(cmdId);
            }
        }
    }

    // Après mise à jour : recalcul si statut devient "Brouillon" ou si quantité change
    public static void afterUpdate(List<Commande__c> newList, Map<Id, Commande__c> oldMap) {
        List<Id> commandeIds = new List<Id>();
        System.debug('afterUpdate déclenché');

        for (Commande__c cmd : newList) {
            Commande__c oldCmd = oldMap.get(cmd.Id);

            Boolean quantiteModifiee = cmd.Quantite_articles__c != oldCmd.Quantite_articles__c;
            Boolean statutRevenuBrouillon = oldCmd.Statut__c != 'Brouillon' && cmd.Statut__c == 'Brouillon';

            if (quantiteModifiee || statutRevenuBrouillon) {
                commandeIds.add(cmd.Id);
                System.debug('Commande modifiée à recalculer : ' + cmd.Id);
            }
        }

        if (!commandeIds.isEmpty()) {
            for (Id cmdId : commandeIds) {
                System.debug('↩️ Recalcul du montant après update : ' + cmdId);
                CalculMontant.calculerMontant(cmdId);
            }
        }
    }
}
