/* 
    @author	Kamil kamran
    @date	05/08/2024
    @group	EQNUIRY_SYNCHRONIZATIONS
    @description This is Web Service Class In Medical org exposed through connected app to Commercial App, 
    Functionality of serving as a gateway for real time synchronizations of the Enquiry and Physician/Medical 
    Professionals
    Also Contains the Parsing logics in methods which will be expanded later.
    @version 1.0
     */
    // Status Deployed
@RestResource(urlMapping = '/Enquiry/*')
global class EnquiryRecieveService {

    /*
    Enquiry POST APEX webService for allowing Commercial orgs to post Enquiry and Physician and medical professional details on the 
    Medical Org.
    */
    @HttpPost
    global static void postEnquiry()
    {
        String PhysicianId;
        String questions;
        system.debug('Testing');
        RestRequest req= RestContext.request;
        EnquiryRawData EnquiryWrapper = new EnquiryRawData();
        EnquiryWrapper = (EnquiryRawData)(JSON.deserialize(((req.requestBody).toString()),EnquiryRawData.class));
        String ExtIds = String.valueOf(EnquiryWrapper.ExternalEnqId);
        System.debug(ExtIds);

        Medical_Enquiry__c newEnquiry = new Medical_Enquiry__c();
        physician__c newPhysician = new physician__c();

        newPhysician.Email__c = EnquiryWrapper.PhysicianEmail;
        newPhysician.Medical_Center__c = EnquiryWrapper.PhysicianEmail;
        newPhysician.Name = EnquiryWrapper.Physician_Name;
        newPhysician.Phone__c = EnquiryWrapper.PhysicianNumber;
        try {
            Database.SaveResult sr = Database.insert(newPhysician);
            PhysicianId = sr.getId();
            system.debug(PhysicianId); // Goes in Logger in Phase II refinement
            }
            
        catch(exception e)
        {
            System.debug(e.getMessage() + ' Caused By - ' + e.getCause());
            // If there were a phase II I would refactor this with  properly Logging the debug lines with
            //Interface Logger Class.

        }
        Savepoint sp = Database.setSavepoint();


            newEnquiry.Name = EnquiryWrapper.EnquiryName;
            newEnquiry.Preferred_Channel__c = EnquiryWrapper.PrefferredResponseChannel;
            newEnquiry.Medicine__c = EnquiryWrapper.Medicine;
            newEnquiry.ExternalUID__c = EnquiryWrapper.ExternalEnqId;
            newEnquiry.Physicians__c = PhysicianId;
            String localQuestions = stringParsegUtility(EnquiryWrapper.Queries);
            newEnquiry.Questions__c = localQuestions;
        try{
            insert newEnquiry;
           }
           catch(exception e)
           {
            system.debug('test'); // Goes in the Logger in the Phase II refinement
            Database.rollback(sp);
           }  
    }

    // Method for parsing contents from Rich Text Editor 
    // Move to String Utility Class in Next Phase
    public static String stringParsegUtility(String queryString)
        {
            String concatinatedQuestionString='';
            String[] splittedQueryList = queryString.split('</p>');
            for(string IndividualQuestions : splittedQueryList)
            {
            String localString=''; 
            localString = IndividualQuestions.replace('<p>', 'Question. - ');
            localString+='\r\n';
            concatinatedQuestionString += localString;
            }
            return concatinatedQuestionString;
        }
}

