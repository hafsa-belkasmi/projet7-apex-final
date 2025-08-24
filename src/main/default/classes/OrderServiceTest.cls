/**
 * Classe de test unitaire pour OrderService.
 * 
 * Objectif principal :
 *  - Vérifier la mise à jour des informations liées à l’expédition d’une commande.
 */
@isTest
public class OrderServiceTest {
      /**
     * Teste la mise à jour des frais d’expédition (Frais_d_expedition__c) d’une commande.
     *
     * Étapes du test :
     *  - Création d’un compte client
     *  - Création et insertion d’une commande associée
     *  - Clonage de la commande et mise à jour du champ Frais_d_expedition__c
     *  - Enregistrement de la mise à jour en base
     *  - Vérification que la valeur Frais_d_expedition__c a bien été modifiée
     */
    @isTest
    static void testUpdateShippingInfo() {
        Account acc = new Account(Name = 'Client Test', Type = 'Client');
        insert acc;

        Commande__c cmd = new Commande__c(
            Nom__c = 'Commande Test',
            Compte__c = acc.Id,
            Quantite_articles__c = 2,
            Statut__c = 'En cours',
            Date__c = Date.today(),
            Type_de_client__c = 'Professionnel',
            R_gion__c = 'Sud'
        );
        insert cmd;

        // Simule une mise à jour des frais de livraison
        Commande__c updatedCmd = cmd.clone(false, false, false, false);
        updatedCmd.Id = cmd.Id;
        updatedCmd.Frais_d_expedition__c = 10.0; // nombre décimal, pas une string

        Test.startTest();
        update updatedCmd;
        Test.stopTest();

        Commande__c result = [
            SELECT Frais_d_expedition__c FROM Commande__c WHERE Id = :cmd.Id
        ];

        System.assertEquals(10.0, result.Frais_d_expedition__c); // bonne comparaison
    }
}
