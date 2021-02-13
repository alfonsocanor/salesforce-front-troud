global class GenericUtilsHelper {		
	
	public static Organization currentOrg;

	public static Boolean isSandboxEnviroment() {
		if (currentOrg == null) {
			currentOrg = [
				SELECT Id, Name, IsSandbox
				FROM Organization
				LIMIT 1
			];
		}
		return currentOrg.isSandbox;
	}

	public static Transport_Service__mdt getWebServiceConfig(String name) {
		Boolean isProduction = !isSandboxEnviroment();  
		List<Transport_Service__mdt> result = [
			SELECT Id, URL__c,GoogleAPIKey__c
			FROM Transport_Service__mdt
			WHERE MasterLabel = :name
			AND Is_Production__c = :isProduction
		]; 
		if(!result.isEmpty()) {
			return result[0];
		} 
		return null;
	}

	static Map<String, RecordType> mapRecordTypes = new Map<String, RecordType> ();
	global static RecordType getRecordType(String SobjectType, String recordTypeName) {
		if (mapRecordTypes.containsKey(SobjectType + '-' + recordTypeName)) {
			return mapRecordTypes.get(SobjectType + '-' + recordTypeName);
		} else {
			List<RecordType> recordType = [
				SELECT Name, SobjectType
				FROM RecordType
				WHERE SobjectType = :SobjectType
					AND Name = :recordTypeName
			];
			if (recordType.size() > 0) {
				mapRecordTypes.put(SobjectType + '-' + recordTypeName, recordType[0]);
				System.debug(recordType[0]);
				return recordType[0];
			} else {
				return null;
			}
		}		
	}

	WebService static Id getRecordTypeToTratamiento(String SobjectType, String recordTypeName) {
		return getRecordType(SobjectType, recordTypeName).Id;
	}
	
	/*******************************************************************************************************	
    * it use format 'sObjectType-recordTypeName'
    */		
	global static RecordType getRecordType(String encodedName) {
		List<String> parameters = encodedName.split('-');
        system.debug(parameters);
        if (parameters.size() == 2) {
			return getRecordType(parameters[0], parameters[1]);            
        } else {
        	return null;
        }        
	}	
}