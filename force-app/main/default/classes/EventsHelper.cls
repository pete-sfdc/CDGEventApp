// all of these publish events were going to look the same,
// so generic seems to be a good pattern
public class EventsHelper {

    public static Platform_Events_Demo_Settings__c Settings = Platform_Events_Demo_Settings__c.getInstance();

    // added the C because insert, update, delete, and undelete are reserved
    public enum DMLContext {INSERT_C,UPDATE_C,DELETE_C,UNDELETE_C}

    public static void publishEvent(List<SObject> objs, DMLContext context) {

        List<New_Customer_Event__e> newEvents = new List<New_Customer_Event__e>();
        String objJSONStr;

        for(SObject obj:objs) {
            // convert obj to JSON
            objJSONStr = JSON.serialize(obj);
            // add new event to list of events
            newEvents.add(new New_Customer_Event__e(
                ObjectRecordID__c = (String)obj.get('Id'),
                Context__c = context.name().replace('_C', ''),
                AdditionalData__c = objJSONStr+''
            ));
        }

        if(newEvents != null && !newEvents.isEmpty()) {
            // a lot of extra code to make sure publishing went well
            List<Database.SaveResult> srs = EventBus.publish(newEvents);
            // this is all for debugging
            for(Database.SaveResult sr:srs) {
                if(sr.isSuccess()) {
                    System.debug('Successfully published event.');
                } else {
                    for(Database.Error err:sr.getErrors()) {
                        System.debug(
                            'Error returned: ' 
                            + err.getStatusCode() 
                            + ' - ' 
                            + err.getMessage()
                        );
                    }
                }
            }
        }
    }
}