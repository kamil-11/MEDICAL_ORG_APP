/* 
    @author	Kamil kamran
    @date	05/08/2024
    @group	EQNUIRY_STATUS_UPDATE
    @description Trigger Controller Doubles as HTTP Callout service for Easy Maintenance and Tweaks 
                 Logic for re-trying Http Request to Commercial App.                   
     */

public with sharing class UpdateInquiryStatusCtrl {

    /*
        Driver Method to perform local DMLs and delegate the Calout control to member methods.
        Implementation is faster for medium volumes since it sperates the thread for each callout.
        This is due to the fact that no bulk operation is anticipated on the current business usecase.
    */
    public static void updateEnquiryStatus(List<Interactions__c> Interactions , Map<Id,Interactions__c> interactionOldMap) {
        String Status;
        List<Medical_Enquiry__c> MIToUpdate = new List<	Medical_Enquiry__c>();
        Set<Id> MedicalInqId = new Set<id>();
        for(Interactions__c interaction : Interactions)
            {                                                   
            Interactions__c oldInteraction = interactionOldMap.get(interaction.Id);
            if((interaction.Status__c != oldInteraction.status__c))
            {
                MedicalInqId.add(interaction.Medical_Enquiry__c);
                Status=interaction.Status__c;
            }
        }
        if(MedicalInqId != null){
        MIToUpdate =[SELECT ID,ExternalUID__c,Name,Status__c FROM Medical_Enquiry__c Where ID In:MedicalInqId];
        for(Medical_Enquiry__c updatingMI: MIToUpdate)
        {
            updatingMI.status__c = Status;
            postToCommercial(updatingMI.ExternalUID__c);
        }
        }
        try{
        update MIToUpdate;
        }
        catch(exception e)
        {
            system.debug('DML Exception occured : -');
            system.debug('Error - '+e+'Caused by - ' +e.getMessage());
        }
    }

    /* 
        Future Method Because it can handle Moderate amount of Volume.   
        Sends the Status with external Unique Identifier to update the records on
        the Commercial.    
    */
    @future(callout=true)
    public Static void postToCommercial(string ExUID)
    {
        String uri ='/services/apexrest//Status'; //This will Go in Custom_Settings
        Medical_Enquiry__c retreiveEnquiry = new Medical_Enquiry__c();
        retreiveEnquiry =[SELECT Id,Name,Medicine__c,ExternalUID__c,Physicians__c,Preferred_Channel__c,Status__c FROM Medical_Enquiry__c Where ExternalUID__c =:ExUID LIMIT 1];
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('Callout:Enquiry_Status_Update' + uri);
        request.setHeader('Content-Type', 'application/json;');
        Map<string,string> jsonBody = new Map<string, string>();
        jsonbody.put('Name',retreiveEnquiry.Name);
        jsonBody.put('External Id',retreiveEnquiry.ExternalUID__c);
        jsonBody.put('Physician', retreiveEnquiry.Physicians__c);
        jsonBody.put('Medicine', retreiveEnquiry.Medicine__c);
        jsonBody.put('Status',retreiveEnquiry.Status__c);
        string JsonSer = JSON.serializePretty(jsonBody);
        system.debug(JsonSer);
        request.setBody(JsonSer);
        request.setMethod('POST');

        HttpResponse response = new Httpresponse();
        try{
            response = http.send(request);
            System.debug(response.getStatus()); // Goes in the Logger class
        }
        catch(exception e)
        {
            system.debug(e.getMessage());
            /*Re-trial to make a HTTP Request to the Commercial App
              again if failed due to Bad body Request Error, This time we send 
              Just the Important fields to atleast send the Important Fields
              and update the client records properly in the same transaction.  
            */
            if(response.getStatus() == 'Bad Request : Tip Please check your request JSON body and make sure it is format Valid')
            {
                jsonBody = null;
                jsonBody.put('External Id',retreiveEnquiry.ExternalUID__c);
                jsonBody.put('Status', 'Closed - Answered');
                JsonSer =null;
                JsonSer = JSON.serializePretty(jsonBody);
                request.setBody(JsonSer);
                http.send(request);
            }
        }

    }
}