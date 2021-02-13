public with sharing class LWCTroudAppController {
	@TestVisible
	public static final Transport_Service__mdt SERVICE_CONFIG =
		GenericUtilsHelper.getWebServiceConfig('TROUD.SERVICE');
    

    @AuraEnabled
    public static List<WrapperRoutes2DisplayOnApp> getTroudRouting(String routeSheetId){
        Set<Id> accountIdSet = new Set<Id>();
        List<WrapperAccount4Routing> accounts4Routing = new List<WrapperAccount4Routing>();
        List<WrapperRoutes2DisplayOnApp> info4Routes2Display = new List<WrapperRoutes2DisplayOnApp>();

        Route_Sheet__c routeSheet = [
            SELECT Id, Warehouse__c
            FROM Route_Sheet__c
            WHERE Id = :routeSheetId
        ];

        Warehouse__c warehouse = [
            SELECT Id, Latitude__c, Longitude__c
            FROM Warehouse__c
            WHERE Id = :routeSheet.Warehouse__c
        ];

        List<Route_Line_Item__c> routeLineList = [
            SELECT Id, Order__r.AccountId
            FROM Route_Line_Item__c
            WHERE Route_Sheet__c = :routeSheetId
        ];

        for(Route_Line_Item__c rli: routeLineList){
            accountIdSet.add(rli.Order__r.AccountId);
        }

        Boolean addWarehouse = true; //Add warehouse first and only once
        for(Account acc: [
                SELECT Id, Name, ShippingLatitude, ShippingLongitude,
                    ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry
                FROM Account
                WHERE Id IN :accountIdSet
            ]){
            if(addWarehouse){
                accounts4Routing.add(
                    new WrapperAccount4Routing(
                        warehouse.Id, 'Warehouse', '','','','','',
                        Decimal.valueOf(warehouse.Latitude__c), 
                        Decimal.valueOf(warehouse.Longitude__c)
                    )
                );

                addWarehouse = false;
            }
            accounts4Routing.add(
                new WrapperAccount4Routing(
                    acc.Id, acc.Name,acc.ShippingStreet, 
                    acc.ShippingCity, acc.ShippingState, acc.ShippingPostalCode, acc.ShippingCountry,
                    acc.ShippingLatitude, acc.ShippingLongitude
                )
            );
        }

        String responseFromTroud = callTroudService(accounts4Routing);

        WrapperRoute routes = (WrapperRoute) JSON.deserialize(responseFromTroud, WrapperRoute.class);
        
        Integer order2Delived = 1;
        for(WrapperAccount4Routing route: routes.routes){
            info4Routes2Display.add(
                new WrapperRoutes2DisplayOnApp(
                    new WrapperLocation(
                        route.ShippingCity,
                        route.ShippingCountry,
                        route.ShippingPostalCode,
                        route.ShippingState,
                        route.ShippingStreet
                    ),
                    route.accountId,
                    String.valueOf(order2Delived) + '. ' + route.name,
                    'standard:account',
                    route.address
            ));
            order2Delived++;
        }

        return info4Routes2Display;
    }

    public static String callTroudService(List<WrapperAccount4Routing> accounts4Routing){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(SERVICE_CONFIG.URL__c + '/routing/calculateRouteByDistance');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(accounts4Routing));
        HttpResponse response = http.send(request);

        return response.getBody();
    }

    public class WrapperAccount4Routing{
        @AuraEnabled public String accountId;
        @AuraEnabled public String name;
        @AuraEnabled public String address;
        @AuraEnabled public String ShippingStreet;
        @AuraEnabled public String ShippingCity;
        @AuraEnabled public String ShippingState; 
        @AuraEnabled public String ShippingPostalCode;
        @AuraEnabled public String ShippingCountry;
        @AuraEnabled public Decimal lat;
        @AuraEnabled public Decimal lng;
        @AuraEnabled public List<Decimal> distancesBetween;
        public WrapperAccount4Routing(
            String accountId,
            String name, 
            String ShippingStreet, 
            String ShippingCity, 
            String ShippingState, 
            String ShippingPostalCode, 
            String ShippingCountry,
            Decimal lat, 
            Decimal lng){
                this.accountId = accountId;
                this.name = name;
                this.address = address;
                this.ShippingStreet = ShippingStreet;
                this.ShippingCity = ShippingCity;
                this.ShippingState = ShippingState;
                this.ShippingPostalCode = ShippingPostalCode;
                this.ShippingCountry = ShippingCountry;
                this.lat = lat;
                this.lng = lng;
        }
    }

    public class WrapperRoute{
        @AuraEnabled public List<WrapperAccount4Routing> routes;
    }

    public class WrapperRoutes2DisplayOnApp{
        @AuraEnabled public WrapperLocation location;
        @AuraEnabled public String value;
        @AuraEnabled public String icon;
        @AuraEnabled public String title;
        @AuraEnabled public String description;
        public WrapperRoutes2DisplayOnApp(
            WrapperLocation location, String value, String title, String icon, String description){
                this.location = location;
                this.value = value;
                this.icon = icon;
                this.title = title;
                this.description = description;
        }
    }

    public class WrapperLocation{
        @AuraEnabled public String City;
        @AuraEnabled public String Country;
        @AuraEnabled public String PostalCode;
        @AuraEnabled public String State;
        @AuraEnabled public String Street;
        public WrapperLocation(String City, String Country, String PostalCode, String State, String Street){
            this.City = City;
            this.Country = Country;
            this.PostalCode = PostalCode;
            this.State = State;
            this.Street = Street;
        }
    }
}