/**
 * Service métier pour la gestion des commandes.
 * 
 * Cette classe fournit des méthodes utilitaires liées à la validation et à la mise à jour
 * des informations d’expédition. 
 */

public class OrderService {
         /**
     * Valide une commande pour un compte de type "Client".
     *
     * Règle métier :
     *  - Si la commande et le compte existent
     *  - Et que le compte est de type "Client"
     *  - Alors la commande est marquée comme "Validée".
     *
     * @param cmd  La commande à valider
     * @param acc  Le compte associé à la commande
     */
    public static void validateOrder(Commande__c cmd, Account acc) {
        if (cmd != null && acc != null && acc.Type == 'Client') {
            cmd.Statut__c = 'Validée';

        }
    }
/**
     * Met à jour les informations d’expédition d’une commande à partir d’un transporteur.
     *
     * Règle métier :
     *  - Si la commande et le transporteur existent
     *  - Alors l’adresse et le coût d’expédition de la commande sont mis à jour.
     *
     * @param cmd     La commande à mettre à jour
     * @param transp  Le transporteur fournissant l’adresse et le coût
     */
    public static void updateShippingInfo(Commande__c cmd, Transporter__c transp) {
        if (cmd != null && transp != null) {
            cmd.ShippingAddress__c = transp.Address__c;
            cmd.ShippingCost__c = transp.Cost__c;
            // PAS de update ici non plus
        }
    }
}
