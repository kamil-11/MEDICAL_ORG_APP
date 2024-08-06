/* 
    @author	Kamil kamran
    @date	05/08/2024
    @group	EQNUIRY STATUS UPDATE
    @description Apex Object for Parsing Json
    @version 1.0
     */
    // Status Deployed

    /*
    User Defined Apex Objects to parse the HTTP Response. Consist of combined Physician and Enquiry details,
    Isolated class and not inner class as during different phases changes on the data model or the Server's parsing logic JSON 
    can be easiliy accomodated. 
    */
public class EnquiryRawData{
    public String PrefferredResponseChannel;	
    public String MedicalCenter;	
    public String Queries;	
    public String PhysicianNumber;	
    public String PhysicianEmail;	
    public String Medicine;	
    public String EnquiryName;	
    public String ExternalEnqId;
    public String Physician_Name;
    }