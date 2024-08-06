/* 
    @author	Kamil kamran
    @date	05/08/2024
    @group	EQNUIRY_STATUS_UPDATE
    @description Trigger for Handling Events for the Enquiry Object Sync
     */
trigger UpdateInquiryStatus on 	Interactions__c (after Update) {

    if(trigger.isAfter && trigger.isUpdate)
    {
        UpdateInquiryStatusCtrl.updateEnquiryStatus(trigger.new , trigger.oldMap);
    }

}