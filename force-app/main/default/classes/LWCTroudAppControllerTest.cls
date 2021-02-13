@isTest
private class LWCTroudAppControllerTest {

    @isTest
    static void whenTheComponentOpensAndTheStatusOfTheRouteIsNotCompletedShouldCallAllTheAccountsWithTheLatLng(){

    }

    @isTest
    static void ifAnAccountDoesntHaveLatLngAnAlertShouldBeDisplayed(){

    }

    @isTest
    static void sendAllTheLatLngToTroudServiceForRoutingCalculation(){

    }

    static Account acc1, acc2;
    static List<Account> accList;
    static Route_Sheet__c route1;
    static Pricebook2 stdPriceBook;
    static Product2 p1, p2, p3;
    static List<Product2> productList;
    static PricebookEntry pbe1, pbe2, pbe3;
    static List<PricebookEntry> pbeList;
    static Order ord1, ord2, ord3;
    static List<Order> ordList;
    static OrderItem oli1, oli2, oli3;
    static List<OrderItem> oliList;
    static{
        stdPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            Name = 'Standard Price Book',
            IsActive = true
        );
        upsert stdPriceBook;

        p1 = new Product2(
            Name = 'Product 1' 
        );
        p2 = new Product2(
            Name = 'Product 2' 
        );
        p3 = new Product2(
            Name = 'Product 3' 
        );
        productList = new List<Product2>{p1, p2, p3};
        insert productList;

        pbe1 = new PricebookEntry(
            isActive = true,
            UnitPrice = 10,
            product2Id = p1.Id,
            pricebook2Id = stdPriceBook.Id
        );
        pbe2 = new PricebookEntry(
            isActive = true,
            UnitPrice = 10,
            product2Id = p2.Id,
            pricebook2Id = stdPriceBook.Id
        );
        pbe3 = new PricebookEntry(
            isActive = true,
            UnitPrice = 10,
            product2Id = p3.Id,
            pricebook2Id = stdPriceBook.Id
        );
        pbeList = new List<PricebookEntry>{pbe1, pbe2, pbe3};
        insert pbeList;

        acc1 = new Account(
            Name = 'Test Account1',
            ShippingStreet = 'Santa Rosa 5040',
            ShippingCity = 'CABA',
            ShippingState = 'Buenos Aires',
            ShippingPostalCode = '1414',
            ShippingCountry = 'Argentina',
            ShippingLatitude = 48.6666, //Lat is configured via Rule Integration https://help.salesforce.com/articleView?id=data_dot_com_clean_admin_automatically_get_geocodes_for_addresses.htm&type=5
            ShippingLongitude = 48.7777 //Lng is configured via Rule Integration https://help.salesforce.com/articleView?id=data_dot_com_clean_admin_automatically_get_geocodes_for_addresses.htm&type=5
        );

        acc2 = new Account(
            Name = 'Test Account2',
            ShippingStreet = 'Av. Dorrego 1409',
            ShippingCity = 'CABA',
            ShippingState = 'Buenos Aires',
            ShippingPostalCode = 'C1414',
            ShippingCountry = 'Argentina',
            ShippingLatitude = 48.8888, //Lat is configured via Rule Integration https://help.salesforce.com/articleView?id=data_dot_com_clean_admin_automatically_get_geocodes_for_addresses.htm&type=5
            ShippingLongitude = 48.9999 //Lng is configured via Rule Integration https://help.salesforce.com/articleView?id=data_dot_com_clean_admin_automatically_get_geocodes_for_addresses.htm&type=5
        );

        accList = new List<Account>{acc1, acc2};
        insert accList;

        ord1 = new Order(
            Status = 'Draft',
            EffectiveDate = Date.Today().addDays(1),
            AccountId = acc1.Id,
            Pricebook2Id = stdPriceBook.Id
        );
        ord2 = new Order(
            Status = 'Draft',
            EffectiveDate = Date.Today().addDays(1),
            AccountId = acc1.Id,
            Pricebook2Id = stdPriceBook.Id
        );
        ordList = new List<Order>{ord1, ord2};
        insert ordList;

        oli1 = new OrderItem(
            product2Id = p1.Id,
            quantity = 1,
            orderId = ord1.Id,
            pricebookEntryId = pbe1.Id,
            UnitPrice = 10
        );
        oli2 = new OrderItem(
            product2Id = p2.Id,
            quantity = 1,
            orderId = ord1.Id,
            pricebookEntryId = pbe2.Id,
            UnitPrice = 10
        );
        oli3 = new OrderItem(
            product2Id = p3.Id,
            quantity = 1,
            orderId = ord1.Id,
            pricebookEntryId = pbe3.Id,
            UnitPrice = 10
        );
        oliList = new List<OrderItem>{oli1, oli2, oli3};
        insert oliList;

        route1 = new Route_Sheet__c();
    }
}
