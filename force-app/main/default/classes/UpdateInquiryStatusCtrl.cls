/* 
    @author	Kamil kamran
    @date	05/08/2024
    @group	EQNUIRY STATUS UPDATE
    @description Trigger Controller Doubles as HTTP Callout service for Easy Maintenance and Tweaks 
     */

public with sharing class UpdateInquiryStatusCtrl {

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

        update MIToUpdate;

    }
    @future(callout=true)
    public Static void postToCommercial(string ExUID)
    {
        String uri ='/services/apexrest//Status';
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
            System.debug(response.getStatus());
        }
        catch(exception e)
        {
            system.debug(e.getMessage());
        }

    }
}