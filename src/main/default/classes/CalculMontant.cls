public class CalculMontant {
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
