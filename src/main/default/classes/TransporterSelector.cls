/**
 * Classe de service permettant de gérer la sélection des transporteurs.
 * 
 * Responsabilités :
 *  - Récupérer les transporteurs disponibles en fonction d’une région donnée
 *  - Identifier le transporteur le plus économique parmi une liste
 */
public with sharing class TransporterSelector {

     /**
     * Récupère la liste des transporteurs disponibles pour une région donnée.
     *
     * Critères :
     *  - Le transporteur doit être actif (IsAvailable__c = TRUE)
     *  - Le transporteur doit couvrir la région passée en paramètre
     *
     * @param region La région de livraison.
     * @return Liste des transporteurs disponibles pour la région.
     */
    public static List<Transporter__c> getAvailableTransporters(String region) {
        return [
            SELECT Id, Name, Address__c, Cost__c, DeliveryTime__c, IsAvailable__c, Type_Client__c, Region__c
            FROM Transporter__c
            WHERE IsAvailable__c = TRUE
              AND Region__c = :region
        ];
    }

    /**
     * Sélectionne le meilleur transporteur parmi une liste, 
     * selon le coût de livraison (Cost__c).
     *
     * Règle :
     *  - Si la liste est vide → retourne null
     *  - Sinon → retourne le transporteur avec le coût le plus bas
     *
     * @param transporters Liste des transporteurs disponibles.
     * @return Le transporteur avec le coût le plus bas, ou null si la liste est vide.
     */
    public static Transporter__c selectBestTransporter(List<Transporter__c> transporters) {
        if (transporters.isEmpty()) {
            return null;
        }

        Transporter__c best = transporters[0];
        for (Transporter__c t : transporters) {
            if (t.Cost__c < best.Cost__c) {
                best = t;
            }
        }
        return best;
    }
}