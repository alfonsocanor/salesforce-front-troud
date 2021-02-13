public with sharing class LWCTroudOrdersByAccountController {

    @AuraEnabled
    public static List<ColumnsWrapper> getOrdersByAccount(String accountId, String routeSheetId){
        Set<Id> orderIdSet = new Set<Id>();
        List<ColumnsWrapper> gridDataTableInformation = new List<ColumnsWrapper>();

        for(Route_Line_Item__c rli: [
            SELECT Id, Order__c
            FROM Route_Line_Item__c
            WHERE 
                Order__r.AccountId = :accountId AND
                Route_Sheet__c = :routeSheetId
        ]){
            orderIdSet.add(rli.Order__c);
        }

        for(Order ord: [
            SELECT Id, OrderNumber,Total_Products__c, Account.Name, CreatedDate, TotalAmount,
                (SELECT Id, Product2.Name, Quantity, CreatedDate, TotalPrice
                 FROM OrderItems)
            FROM Order
            WHERE Id IN :orderIdSet
        ]){
            List<ColumnsWrapper> childrenList = new List<ColumnsWrapper>();

            if(!ord.OrderItems.isEmpty()){
                for(OrderItem oli: ord.OrderItems){
                    childrenList.add(
                        new ColumnsWrapper(
                            oli.Id,    
                            oli.Product2.Name,
                            Date.valueOf(oli.CreatedDate),
                            oli.TotalPrice,
                            oli.Quantity,
                            null
                        )
                    );
                }
            }

            gridDataTableInformation.add(
                new ColumnsWrapper(
                    ord.Id,
                    ord.OrderNumber,
                    Date.valueOf(ord.CreatedDate),
                    ord.TotalAmount,
                    ord.Total_Products__c,
                    childrenList
                )
            );
        }


        return gridDataTableInformation;
    }

    public class ColumnsWrapper{
        @AuraEnabled public String url;
        @AuraEnabled public String name;
        @AuraEnabled public Date orderDate;
        @AuraEnabled public Decimal totalAmount;
        @AuraEnabled public Decimal productQuantity;
        @AuraEnabled public List<ColumnsWrapper> children;
        public ColumnsWrapper(String url, String name, Date orderDate, Decimal totalAmount, Decimal productQuantity, List<ColumnsWrapper> children){
            this.url = '/' + url;
            this.name = name;
            this.orderDate = orderDate;
            this.totalAmount = totalAmount;
            this.productQuantity = productQuantity;
            this.children = children;
        }
    }
}