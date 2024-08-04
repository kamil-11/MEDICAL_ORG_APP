public class EnquiryStatusService {
    /* 
    @author	Kamil kamran
    @date	05/08/2024
    @group	EQNUIRY STATUS UPDATE
    @description This is HTTP Callout service for callout to Commercial org connected app to Commercial App
     */
    // *******************************        Status - UnderDevelopment        *****************************
        @future(callout=true)
        public static void PostEnquiry() {
            String uri ='/services/apexrest/Status';
    
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('Callout:Enquiry_Status_Update' + uri);
            request.setHeader('Content-Type', 'application/json;');
            Map<string,string> jsonBody = new Map<string, string>();
            jsonbody.put('Name','kamil');
            jsonBody.put('Status','Development');
            string JsonSer = JSON.serializePretty(jsonBody);
            request.setBody(JsonSer);
            request.setMethod('POST');
    
            HttpResponse response = new Httpresponse();
            
            try{
                response = http.send(request);
                system.debug(response.getStatus());
            }
            catch(exception e)
            {
                system.debug(e.getMessage());
            }
        }
    }
