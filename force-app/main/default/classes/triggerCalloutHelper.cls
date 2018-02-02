global class triggerCalloutHelper {

    @future(callout=true)
    public static void notifyRemoteSystem(Set<Id> recordIds) {
       List<SObject> records = getRecords(recordIds);
       sendToFinancialSystem(records);
       sendToERPSystem(records);
    }

    private static List<SObject> getRecords(Set<Id> recordIds) {
        List<SObject> objList;
        Schema.SObjectType type;
        for(Id recordId:recordIds) {
            type = recordId.getSobjectType();
            break;
        }
        if(type == Account.SObjectType) {
            objList = (List<SObject>)[
                SELECT  Id, Name, CreatedDate 
                FROM    Account 
                WHERE   Id =:recordIds
            ];
        } else if(type == Contact.SObjectType) {
            objList = (List<SObject>)[
                SELECT  Id, Name, CreatedDate, AccountId
                FROM    Contact 
                WHERE   Id =:recordIds
            ];
        }
        return objList;
    }

    private static void sendToFinancialSystem(List<SObject> records) {
        for(SObject record:records) {
            sendCallout(record, EventsHelper.Settings.Financial_System_Endpoint__c);
        }
    }

    private static void sendToERPSystem(List<SObject> records) {
        for(SObject record:records) {
            sendCallout(record, EventsHelper.Settings.ERP_System_Endpoint__c);
        }
    }

    private static HttpResponse sendCallout(SObject obj, String endpoint) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        String body = JSON.serialize(obj);
        req.setMethod('POST');
        req.setBody(body);
        req.setHeader('content-type', 'application/json');
        String routeStr = '/upsertRecord/' + obj.get('Id');
        req.setEndpoint(endpoint + routeStr);
        res =  h.send(req);
        return res;
    }
}
