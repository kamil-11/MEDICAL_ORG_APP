/* 
    @author	Kamil kamran
    @date	05/08/2024
    @group	EQNUIRY STATUS UPDATE
    @description Aura Enabled Apex Controller for Upcomming Versions of LWC (Phase II) - for adding Search Component on
    Interactions Object This will enhance the user Interphase
     */

     // *******************************        Status - UnderDevelopment        *****************************

public with sharing class GetPhysicianCTRL {
    @auraEnabled(cacheable=true)
    public static List<Physician__c> getPhysician(String searchKey)
    {
        String Key = '%'+searchKey+'%';
        return [Select Id,Name,Phone__c,Email__c,Medical_center__c FROM Physician__c WHERE Name LIKE :Key];
    }
}