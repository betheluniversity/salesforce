/**
* Created by Luke Vang (contractor)
*/
@isTest
public class OpportunityReferencesTest {
    
    @testSetup
    public static void testSetup(){
        Application_Control__c appControl = new Application_Control__c(
            Application_Start_Status__c=Application_Control__c.Application_Start_Status__c.getDescribe().getPicklistValues()[0].getValue(),
            Active__c=true,
            Allow_Cancel_From__c=Application_Control__c.Allow_Cancel_From__c.getDescribe().getPicklistValues()[0].getValue(),
            Allow_Withdraw_From__c=Application_Control__c.Allow_Withdraw_From__c.getDescribe().getPicklistValues()[0].getValue(),
            Allow_Submit_From__c=Application_Control__c.Allow_Submit_From__c.getDescribe().getPicklistValues()[0].getValue(),
            Cancel_Status__c=Application_Control__c.Cancel_Status__c.getDescribe().getPicklistValues()[0].getValue(),
            Default__c=true,
            URL_Parameter__c ='st',
            Submit_Status__c=Application_Control__c.Submit_Status__c.getDescribe().getPicklistValues()[0].getValue(),
            Withdraw_Status__c=Application_Control__c.Withdraw_Status__c.getDescribe().getPicklistValues()[0].getValue()
        );
        insert appControl;
        
        Account acc = new Account(Name='NewAcc');
        insert acc;
        Contact student = new Contact(LastName='TestStudent');
        
        
      	   Contact ref1 = new Contact(LastName='Ref1');

        
           Contact ref2 = new Contact(LastName='Ref2');

        
           Contact ref3 = new Contact(LastName='Ref3');
 		
        insert new List<Contact>{student, ref1, ref2, ref3};
        
        Application__c app = new Application__c(Contact__c=student.Id,Application_Status__c=Application__c.Application_Status__c.getDescribe().getPicklistValues()[0].getValue());
        insert app;
        
        Map<String,Id> rtMap = new Map<String,Id>();
        for(RecordType rt : [Select Id,DeveloperName from RecordType where sObjectType = 'Requirement_Item__c']){
            rtMap.put(rt.DeveloperName,rt.Id);
        }
        
        Program__c ip = new Program__c(Name='Test');
        insert ip;
        
        Requirement__c req = new Requirement__c(Active__c = true,Name='Test Req',Application_Control__c=appControl.Id);
        insert req;
        Requirement_Item__c riQG = new Requirement_Item__c(Requirement__c=req.Id,Name='Test RI',Active__c = true,RecordTypeId=rtMap.get('Question_Group'));
        Requirement_Item__c riDU = new Requirement_Item__c(Requirement__c=req.Id,Name='Test RI',Active__c = true,Allow_Text_Entry__c = true,RecordTypeId=rtMap.get('Document_Upload'));
        Requirement_Item__c riRO = new Requirement_Item__c(Requirement__c=req.Id,Name='Test RI',Active__c = true,RecordTypeId=rtMap.get('Related_Object'),Related_List_Object__c='Application__c',Related_List_Object_Master__c='Contact',Related_List_Object_Master_Field__c='Contact__c', Holding_Record_Id__c=ip.Id);
        insert new List<Requirement_Item__c>{riQG,riDU,riRO};
            
          
            
           Reference__c reference1 = new Reference__c(Contact__c = ref1.Id);
         Reference__c reference2 = new Reference__c(Contact__c = ref2.Id);
         Reference__c reference3 = new Reference__c(Contact__c = ref3.Id);
        insert new List<Reference__c>{reference1, reference2, reference3};
            
              Requirement_Response__c response1 = new Requirement_Response__c(Reference__c = reference1.Id, Application__c = app.Id, Requirement_Item__c = riQG.Id);
        Requirement_Response__c response2 = new Requirement_Response__c(Reference__c = reference2.Id, Application__c = app.Id, Requirement_Item__c = riDU.Id);
        Requirement_Response__c response3 = new Requirement_Response__c(Reference__c = reference3.Id, Application__c = app.Id, Requirement_Item__c = riRO.Id);
         insert new List<Requirement_Response__c>{response1, response2, response3};
            }
    
    static testMethod void testGetReferences(){
        String appId = [SELECT id FROM Application__c].Id;
        List<Reference__c> expected = [SELECT id FROM Reference__c];
        List<Reference__c> result = OpportunityReferences.getReferences(appId);
        System.assertEquals(expected.size(), result.size()); //3 references created in test setup
    }
}