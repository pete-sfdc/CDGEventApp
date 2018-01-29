global class triggerCalloutHelper {
    
    @future(callout=true)
    public static void notifyRemoteSystem(string recordId){
        string body = '';
        if(recordId.startsWith('001')){
            Account a = [select id, name, createdDate from account where id = :recordId];
            body = JSON.serialize(a);
        }else if(recordId.startsWith('003')){
            Contact c = [select id, name, createdDate, accountID from Contact where id = :recordId];
            body = JSON.serialize(c);
        }
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        //CHANGE THIS ENDPOINT URL TO YOUR HEROKU APP BROMONTANA
        //AND YOU PROBABLY NEED A REMOTE SITE SETTING TOO, JUST SAYIN
        req.setEndpoint('https://cdg-node-events.herokuapp.com/upsertRecord/' + recordId);
        req.setMethod('POST');
        req.setBody(body);
        req.setHeader('content-type', 'application/json');
        system.debug(body);
        httpResponse res = h.send(req);
    }
}
