public with sharing class TransporterSelector {

    /**
     * Récupère la liste des transporteurs disponibles pour une région donnée.
     * @param region La région de livraison.
     * @return Liste des transporteurs disponibles.
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
     * Sélectionne le meilleur transporteur parmi une liste, selon le coût de livraison.
     * @param transporters Liste des transporteurs disponibles.
     * @return Le transporteur avec le coût le plus bas.
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