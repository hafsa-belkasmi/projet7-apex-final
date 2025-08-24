/**
 * Classe de test unitaire pour CommandeTriggerHandler.
 * 
 * Objectif :
 *  - Vérifier la règle métier interdisant plus d’une commande en brouillon par compte.
 */
@isTest
public class CommandeTriggerHandlerTest {
     /**
     * Teste que l’insertion de deux commandes en brouillon pour le même compte
     * entraîne une erreur sur la deuxième commande.
     *
     * Étapes du test :
     *  - Création d’un compte client
     *  - Récupération d’une valeur valide de la picklist Type_de_client__c
     *  - Création de deux commandes en brouillon associées au même compte
     *  - Insertion en bulk (allOrNone = false) pour simuler la contrainte
     *  - Vérification :
     *      - la première commande est acceptée
     *      - la deuxième commande échoue avec le message attendu
     */

    @isTest
    static void testUnBrouillonParClient() {
        // Création d’un compte client
        Account acc = new Account(Name = 'Client B', Type = 'Client');
        insert acc;

        //  Sécurisation de l'accès à la picklist
        List<Schema.PicklistEntry> valeursPicklist = Commande__c.Type_de_client__c.getDescribe().getPicklistValues();
        String typeClientValide;

        if (!valeursPicklist.isEmpty()) {
            typeClientValide = valeursPicklist[0].getValue();
        } else {
            // Valeur par défaut si la picklist est vide (à adapter si besoin)
            typeClientValide = 'Client';
        }

        // Création de deux commandes en brouillon pour le même client
        Commande__c cmd1 = new Commande__c(
            Name = 'CMD 1',
            Compte__c = acc.Id,
            Quantite_articles__c = 1,
            Statut__c = 'Brouillon',
            Date__c = Date.today(),
            Type_de_client__c = typeClientValide,
            R_gion__c = 'Nord'
        );

        Commande__c cmd2 = new Commande__c(
            Name = 'CMD 2',
            Compte__c = acc.Id,
            Quantite_articles__c = 2,
            Statut__c = 'Brouillon',
            Date__c = Date.today(),
            Type_de_client__c = typeClientValide,
            R_gion__c = 'Nord'
        );

        Test.startTest();

        // Insertion en bulk avec allOrNone = false
        Database.SaveResult[] results = Database.insert(new List<Commande__c>{ cmd1, cmd2 }, false);

        Test.stopTest();

        // Vérification
        System.assert(results[0].isSuccess(), 'La première commande aurait dû être insérée.');

        //System.assert(!results[1].isSuccess(), 'La deuxième commande aurait dû échouer.');//
        System.assert(
            results[1].getErrors()[0].getMessage().contains('une seule commande en brouillon'),
            'Le message d’erreur attendu n’a pas été trouvé. Reçu : ' + results[1].getErrors()[0].getMessage()
        );
    }
}
