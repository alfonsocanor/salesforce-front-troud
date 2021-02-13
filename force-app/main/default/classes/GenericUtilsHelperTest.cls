@IsTest
private class GenericUtilsHelperTest {

	@isTest static void testBigCommerceMetadata() {
        System.assertNotEquals(null, GenericUtilsHelper.getWebServiceConfig('SALESFORCE.BIGCOMMERCE'));
    }

	@IsTest static void testGetRecordTypeReturnRecordTypeIfExist() {
		List<RecordType> rts = [
			SELECT id, Name,
				SobjectType
			FROM RecordType 
			LIMIT 1
		];        
		if (rts.size() > 0) {
			System.assertNotEquals(null, GenericUtilsHelper.getRecordType(rts[0].sObjectType, rts[0].Name));
		}		
	}
    
	@IsTest static void testGetRecordTypeShouldUseOneQueryForSameRecordType() {
		List<RecordType> rts = [
			SELECT id, Name,
				SobjectType
			FROM RecordType 
			LIMIT 1
		];
        System.debug(Limits.getQueries());
		if (rts.size() > 0) {
			System.assertNotEquals(null, GenericUtilsHelper.getRecordType(rts[0].sObjectType, rts[0].Name));            
            GenericUtilsHelper.getRecordType(rts[0].sObjectType, rts[0].Name);            
            System.assertEquals(2, Limits.getQueries());
		}		
	}    
        
	@IsTest static void testGetRecordTypeEncodedReturnNullIfWasWrongEcnoded() {
		List<RecordType> rts = [
			SELECT id, Name,
				SobjectType
			FROM RecordType 
			LIMIT 1
		];
		if (rts.size() > 0) {
			System.assertEquals(null, GenericUtilsHelper.getRecordType(rts[0].sObjectType + '!' + rts[0].Name));
		}		
	}        
    
	@IsTest static void testGetRecordTypeReturnNullIfRecordTypeIDoesntExist() {		
		System.assertEquals(null, GenericUtilsHelper.getRecordType(',.!'  ,' '));
	}        
}