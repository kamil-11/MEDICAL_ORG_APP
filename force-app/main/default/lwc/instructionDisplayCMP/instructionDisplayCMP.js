import { LightningElement,api, track } from 'lwc';
import LogoImage from '@salesforce/resourceUrl/KOMODOL'
import {ShowToastEvent} from 'lightning/platformShowToastEvent'
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import INTERACTION_OBJECT from '@salesforce/schema/Interactions__c';
import NAME_FIELD from '@salesforce/schema/Interactions__c.Name';
import CREATEDBY_FIELD from '@salesforce/schema/Interactions__c.CreatedById';
import LASTMODIFIEDBY_FIELD from '@salesforce/schema/Interactions__c.LastModifiedById';
import LASTMODIFIEDDATE_FIELD from '@salesforce/schema/Interactions__c.LastModifiedDate';
import MEDICALENQUIRY_FIELD from '@salesforce/schema/Interactions__c.Medical_Enquiry__c';
import NOTES_FIELD from '@salesforce/schema/Interactions__c.Notes__c';
import PHYSICIAN_FIELD from '@salesforce/schema/Interactions__c.Physicians__c';
import OWNERID_FIELD from '@salesforce/schema/Interactions__c.OwnerId';
import CHANNEL_FIELD from '@salesforce/schema/Interactions__c.Channel__c';
import STATUS_FIELD from '@salesforce/schema/Interactions__c.Status__c';
export default class InstructionDisplayCMP extends LightningElement {

    @track customIconUrl;
    connectedCallback()
    {
        this.customIconUrl = `${LogoImage}#demo`;
    }
    objectName = INTERACTION_OBJECT;
    fields={
        namefield :NAME_FIELD,
        createdByField:CREATEDBY_FIELD,
        lastModifiedByField:LASTMODIFIEDBY_FIELD,
        lastModifiedDateField:LASTMODIFIEDDATE_FIELD,
        medicalEnquiryFiel:MEDICALENQUIRY_FIELD,
        notesField:NOTES_FIELD,
        physicianField:PHYSICIAN_FIELD,
        ownerIDField:OWNERID_FIELD,
        channelField:CHANNEL_FIELD,
        statusField:STATUS_FIELD
    }
    @api recordId;
    handler(event)
    {
      const toastEvent =  new ShowToastEvent({
            title:"Status Changed",
            message:"Status sent to Commercial Org",
            variant:"success"
        })

        this.dispatchEvent(toastEvent);
    }
}