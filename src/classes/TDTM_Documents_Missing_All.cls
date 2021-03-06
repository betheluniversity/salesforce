/**
 * Created by ejc84332 on 2019-05-18.
 */


// Test: OpportunityHelperTest

global class TDTM_Documents_Missing_All extends TDTMVirtualTriggerHandler {



    global override void onBeforeUpdate(List<SObject> newList, List<SObject> oldList, Map<Id, SObject> newMap, Map<Id, SObject> oldMap, hed.TDTM_Runnable.DmlWrapper wrapper) {

        List<Opportunity> opps = (List<Opportunity>)newList;

        List<Id> contact_ids = new List<Id>();
        List<Id> app_ids = new List<Id>();
        List<Opportunity> process_opps = new List<Opportunity>();

        for( Opportunity o : opps){
            if((o.StageName == 'Applied'|| o.StageName == 'Accepted' || o.StageName == 'Confirmed' )
                    && o.Lock_Documents_Missing__c == False
                    && o.Academic_Program_Code__c != '1-CRT-BAS'){
                contact_ids.add(o.Contact__c);
                app_ids.add(o.Application__c);
                process_opps.add(o);
            }
        }

        // exit if there are no Opps that fit the Stage criteria.
        if(process_opps.size() == 0){
            return;
        }

        List<Test_Score__c> test_scores = [select Id, Document_Status__c, Test_Type__c, Contact__c from Test_Score__c
                                            where Document_Status__c in ('Conditional', 'Provisional', 'Mandatory', '') and Contact__c in :contact_ids];


        List<Requirement_Response__c> cas_test_scores = [select Id, Name, Fulfilled_On__c, Requirement_Item__r.Label__c, Application__c
                                                        from Requirement_Response__c
                                                        where Requirement_Item__r.Name like '%ACT OR SAT%'
                                                        and Application__r.School_College__c = 'Undergraduate'
                                                        and Fulfilled_On__c = null
                                                        and Application__c in :app_ids

        ];

        List<Admissions_Document__c> admissions_documents = [select Id, Status__c, Type__c, Contact__c from Admissions_Document__c
                                                                 where Status__c in ('Conditional', 'Provisional', 'Mandatory', '') and Contact__c in :contact_ids];

        List<Education_History__c> ed_histories = [select Id, Document_Status__c, Best_School_Name__c, Contact__c from Education_History__c
                                                    where Document_Status__c in ('Conditional', 'Provisional', 'Mandatory', '') and Contact__c in :contact_ids];

        List<Question_Response__c> internal = [
                select Id, Question__r.Name, Question_Label__c, ValueText__c, IsComplete__c, Requirement_Response__r.Application__c
                from Question_Response__c
                where IsShown__c = TRUE
                and ValueText__c in ('Conditional', 'Provisional')
                and Requirement_Response__c in (select Id from Requirement_Response__c where Requirement_Item__r.Name like '%Prerequisites%')
                and (not Question__r.Name like '%GPA%')
                and (not Question__r.Name like '%Degree%')
         ];

//        List<Reference__c> refs = [ SELECT Id, Type__c from Reference__c where Signature__c = 'Conditional' or Signature__c = 'conditional' and Req];


        // GET APP IDS AND FILTER BY THAT?
        List<Requirement_Response__c> rrs = [select Id, Application__c, Requirement_Item__r.Label__c from Requirement_Response__c where Reference__r.Signature__c in ('Conditional', 'conditional', 'Provisional', 'provisional')
            and Requirement_Item__r.Name like '%Reference' and Application__c in :app_ids ];


        // todo, break this out into two functions, CSG and CAS?
        for( Opportunity o : process_opps){

            Boolean csg_opp = o.School_College__c != 'Undergraduate';
            Boolean undergrad_opp = !csg_opp;

            List<String> lines = new List<String>();

            for (Admissions_Document__c ad : admissions_documents){
                if(ad.Contact__c == o.Contact__c){

                    Boolean cond_or_prov = ad.Status__c == 'Conditional' || ad.Status__c == 'Provisional';
                    if(undergrad_opp && (o.Student_Type__c == 'PSEO' || o.Is_International__c)){
                        lines.add('- ' + ad.Type__c);
                    }else if(csg_opp && cond_or_prov){
                        lines.add('- ' + ad.Type__c);
                    }
                }
            }

            for (Education_History__c eh : ed_histories){
                if(eh.Contact__c == o.Contact__c){

                    Boolean cond_or_prov = eh.Document_Status__c == 'Conditional' || eh.Document_Status__c == 'Provisional';
                    if(undergrad_opp){
                        lines.add('- Transcript: ' + eh.Best_School_Name__c);
                    }else if(csg_opp && cond_or_prov){
                        lines.add('- Transcript: ' + eh.Best_School_Name__c);
                    }
                }
            }

            // CAS Uses requirement responses for test scores
            if(undergrad_opp){
                for (Requirement_Response__c rr : cas_test_scores){
                    if(rr.Application__c == o.Application__c){
                        lines.add('- ' + rr.Requirement_Item__r.Label__c);
                    }
                }
            }

            // only CSG gets references and internal requirements
            // only CSG Opps use Test_Score_Object
            if(csg_opp){
                for (Test_Score__c ts : test_scores){
                    Boolean cond_or_prov = ts.Document_Status__c == 'Conditional' || ts.Document_Status__c == 'Provisional';
                    if(ts.Contact__c == o.Contact__c && cond_or_prov){
                        lines.add('- ' + ts.Test_Type__c + ' test score');
                    }
                }
                for (Requirement_Response__c rr : rrs){
                    if(rr.Application__c == o.Application__c){
                        lines.add('- ' + rr.Requirement_Item__r.Label__c);
                    }
                }
                for (Question_Response__c i : internal){
                    if( i.Requirement_Response__r.Application__c == o.Application__c ){
                        lines.add('- Prerequisite: ' + i.Question_Label__c);
                    }
                }
            }




            lines.sort();
            String new_documents_missng = String.join(lines, '\n');

            if(o.Documents_Missing__c != new_documents_missng){
                o.Documents_Missing__c = new_documents_missng;
            }

        }

    }

}