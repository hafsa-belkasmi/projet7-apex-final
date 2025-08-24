/**
 * Classe de test unitaire pour TransporterSelector.
 * 
 * Objectif :
 *  - Vérifier la récupération des transporteurs disponibles par région
 *  - Vérifier la sélection du meilleur transporteur (coût le plus bas)
 */

@isTest
public class TransporterSelectorTest {

    /**
     * Teste les méthodes getAvailableTransporters et selectBestTransporter.
     *
     * Étapes du test :
     *  - Création de 3 transporteurs :
     *      - T1 : disponible, coût 15
     *      - T2 : disponible, coût 10 (meilleur)
     *      - T3 : non disponible, coût 20 (ignoré)
     *  - Insertion en base
     *  - Vérification que seuls 2 transporteurs disponibles sont renvoyés
     *  - Vérification que le transporteur au coût le plus bas (T2) est sélectionné
     */
    @isTest
    static void testGetAvailableTransportersAndBest() {
        // Données de test
        String testRegion = 'Île-de-France';

        Transporter__c t1 = new Transporter__c(
            Name = 'T1',
            Address__c = 'Adresse 1',
            Cost__c = 15.00,
            DeliveryTime__c = 3,
            IsAvailable__c = true,
            Type_Client__c = 'Particulier',
            Region__c = testRegion
        );

        Transporter__c t2 = new Transporter__c(
            Name = 'T2',
            Address__c = 'Adresse 2',
            Cost__c = 10.00, // meilleur coût
            DeliveryTime__c = 2,
            IsAvailable__c = true,
            Type_Client__c = 'Particulier',
            Region__c = testRegion
        );

        Transporter__c t3 = new Transporter__c(
            Name = 'T3',
            Address__c = 'Adresse 3',
            Cost__c = 20.00,
            DeliveryTime__c = 4,
            IsAvailable__c = false, // ne sera pas sélectionné
            Type_Client__c = 'Particulier',
            Region__c = testRegion
        );

        insert new List<Transporter__c>{ t1, t2, t3 };

        // Appel de la méthode à tester
        List<Transporter__c> available = TransporterSelector.getAvailableTransporters(testRegion);

        System.assertEquals(2, available.size(), 'Il doit y avoir 2 transporteurs disponibles');

        // Tester le meilleur transporteur
        Transporter__c best = TransporterSelector.selectBestTransporter(available);
        System.assertEquals(t2.Id, best.Id, 'Le meilleur transporteur devrait être T2');
    }
}