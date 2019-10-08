<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <actionOverrides>
        <actionName>Tab</actionName>
        <content>ITS_Admin_Home_Page</content>
        <formFactor>Large</formFactor>
        <skipRecordTypeSelect>false</skipRecordTypeSelect>
        <type>Flexipage</type>
        <pageOrSobjectType>standard-home</pageOrSobjectType>
    </actionOverrides>
    <actionOverrides>
        <actionName>View</actionName>
        <comment>Action override created by Lightning App Builder during activation.</comment>
        <content>Case_Record_Page_ITS</content>
        <formFactor>Large</formFactor>
        <skipRecordTypeSelect>false</skipRecordTypeSelect>
        <type>Flexipage</type>
        <pageOrSobjectType>Case</pageOrSobjectType>
    </actionOverrides>
    <brand>
        <headerColor>#000000</headerColor>
        <logo>bethellogoverticalcolor7</logo>
        <logoVersion>1</logoVersion>
        <shouldOverrideOrgTheme>false</shouldOverrideOrgTheme>
    </brand>
    <description>Personalized home for ITS Project Management and Analysis.</description>
    <formFactors>Large</formFactors>
    <isNavAutoTempTabsDisabled>false</isNavAutoTempTabsDisabled>
    <isNavPersonalizationDisabled>false</isNavPersonalizationDisabled>
    <label>ITS - Analysis</label>
    <navType>Standard</navType>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>Campaign_Record_Page_Event</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Campaign</pageOrSobjectType>
        <recordType>Campaign.Event_Campaign_Record</recordType>
        <type>Flexipage</type>
        <profile>Admissions - CAS</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>Campaign_Record_Page_Event</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Campaign</pageOrSobjectType>
        <recordType>Campaign.Event_Campaign_Record</recordType>
        <type>Flexipage</type>
        <profile>Admissions - Post-Trad</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>Campaign_Record_Page_Event</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Campaign</pageOrSobjectType>
        <recordType>Campaign.Event_Campaign_Record</recordType>
        <type>Flexipage</type>
        <profile>ITS - Analyst</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>View</actionName>
        <content>Campaign_Record_Page_Event</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>Campaign</pageOrSobjectType>
        <recordType>Campaign.Event_Campaign_Record</recordType>
        <type>Flexipage</type>
        <profile>Admin</profile>
    </profileActionOverrides>
    <tabs>standard-home</tabs>
    <tabs>standard-Task</tabs>
    <tabs>standard-report</tabs>
    <tabs>standard-Case</tabs>
    <tabs>standard-Contact</tabs>
    <tabs>standard-Opportunity</tabs>
    <uiType>Lightning</uiType>
    <utilityBar>ITS_Analysis_UtilityBar</utilityBar>
</CustomApplication>