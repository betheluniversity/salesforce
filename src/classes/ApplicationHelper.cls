public with sharing class ApplicationHelper {

    public final static String ADULT_UNDERGRADUATE_SCHOOL = 'Adult Undergraduate';
    public final static String UNDERGRADUATE_SCHOOL = 'Undergraduate';
    public final static String GRADUATE_SCHOOL = 'Graduate';
    public final static String SEMINARY_SCHOOL = 'Seminary';

    public final static String FRESHMAN_TYPE = 'Freshman';
    public final static String GRADUATE_TYPE = 'Graduate';
    public final static String TRANSFER_TYPE = 'Transfer';
    public final static String PSEO_TYPE = 'PSEO';


	public static void updateFilters(List<Application__c> newList) {
        Set<Id> contactIds = new Set<Id>();
        for (Application__c app : newList) {
            contactIds.add(app.Contact__c);
        }
        Map<Id, Contact> contactMap = ContactHelper.getContactMap(contactIds);
        for (Application__c app : newList) {
            Contact c = contactMap.get(app.Contact__c);
            updateApplicantType(app);
            updateResidency(app, c);
        }
	}

    public static void updateApplicantType(Application__c app) {
        if (app.School_College__c == UNDERGRADUATE_SCHOOL) {
            if (app.Is_Transfer_Student__c) {
                app.Applicant_Type__c = TRANSFER_TYPE;
            }
            else if (app.Is_Applying_For_PSEO__c) {
                app.Applicant_Type__c = PSEO_TYPE;
            }
            else {
                app.Applicant_Type__c = FRESHMAN_TYPE;
            }
        }
        else if (app.School_College__c == ADULT_UNDERGRADUATE_SCHOOL) {
            if (app.College_Credits_Transferred__c != null) {
                if (app.College_Credits_Transferred__c != 'No transfer credits') {
                    app.Applicant_Type__c = TRANSFER_TYPE;
                }
                else {
                    app.Applicant_Type__c = FRESHMAN_TYPE;
                }
            }
        }
        else if (app.School_College__c == GRADUATE_SCHOOL) {
            app.Applicant_Type__c = GRADUATE_TYPE;
        }
    }

    public static void updateResidency(Application__c app, Contact c) {
        if (c.MailingStateCode != null) {
            if (c.MailingStateCode == 'MN') {
                app.Residency__c = 'Resident';
            }
            else {
                app.Residency__c = 'Non-Resident';
            }
        }
    }
}