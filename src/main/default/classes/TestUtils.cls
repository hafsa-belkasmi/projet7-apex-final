/**
 * Classe utilitaire de test.
 * 
 * Fournit des méthodes statiques pour créer facilement
 * des données de test réutilisables (ex. comptes).
 */

public class TestUtils {
    /**
    * Crée et insère un compte de test avec le type spécifié.
    *
    * @param type  Le type de compte (ex. "Client", "Partenaire", etc.)
    * @return      L’enregistrement Account créé et inséré
    */
    public static Account createTestAccount(String type) {
        Account acc = new Account(Name='Test Account', Type=type);
        insert acc;
        return acc;
    }
}