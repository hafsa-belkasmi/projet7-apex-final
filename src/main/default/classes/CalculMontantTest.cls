@isTest
public class CalculMontantTest {
    @isTest
    static void testCalculMontantAvecZero() {
        // Créer un compte client
        Account acc = new Account(Name = 'Client A', Type = 'Client');
        insert acc;

        // Créer une commande avec 0 article
        Commande__c cmd = new Commande__c(
            Name = 'Test CMD',
            Compte__c = acc.Id,
            Quantite_articles__c = 0,
            Statut__c = 'Brouillon',
            Date__c = Date.today(),
            Type_de_client__c = 'Particulier',
            R_gion__c = 'Nord' // Nom de champ corrigé
        );
        insert cmd;

        Test.startTest();
        CalculMontant.calculerMontant(cmd.Id);
        Test.stopTest();

        cmd = [SELECT Montant__c FROM Commande__c WHERE Id = :cmd.Id];
        System.assert(cmd.Montant__c != null, 'Montant__c ne doit pas être null');
    }
}
