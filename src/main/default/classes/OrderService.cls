public class OrderService {
    public static void validateOrder(Commande__c cmd, Account acc) {
        if (cmd != null && acc != null && acc.Type == 'Client') {
            cmd.Statut__c = 'Validée';
            // PAS de update ici
        }
    }

    public static void updateShippingInfo(Commande__c cmd, Transporter__c transp) {
        if (cmd != null && transp != null) {
            cmd.ShippingAddress__c = transp.Address__c;
            cmd.ShippingCost__c = transp.Cost__c;
            // PAS de update ici non plus
        }
    }
}
