/**
 * Classe utilitaire permettant de calculer le montant d'une commande.
 * Le montant est basé sur la quantité d’articles et un prix unitaire fixe.
 */
public class CalculMontant {
      /**
     * Calcule et met à jour le champ Montant__c d’une commande.
     *
     * @param commandeId  l’Id de la commande (Commande__c) à traiter
     * La méthode :
     *  - Récupère la commande en base
     *  - Calcule le montant (quantité * 10)
     *  - Met à jour le champ Montant__c de l’enregistrement
     */
    public static void calculerMontant(Id commandeId) {
        Commande__c cmd = [SELECT Id, Quantite_articles__c FROM Commande__c WHERE Id = :commandeId LIMIT 1];

        Decimal montant = 0;
        if (cmd.Quantite_articles__c != null) {
            montant = cmd.Quantite_articles__c * 10; // prix unitaire
        }

        cmd.Montant__c = montant;
        update cmd;
    }
}
