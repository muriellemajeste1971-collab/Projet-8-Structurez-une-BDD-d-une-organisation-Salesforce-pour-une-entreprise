public with sharing class TripSelector {

    public static List<Trip__c> selectByOppIds(List<Id> oppIds) {

        return [
            SELECT Id, Name, Status__c, Opportunity__c, Account__c, Destination__c, Start_Date__c, End_Date__c, Number_of_Participants__c
            FROM Trip__c
            WHERE Opportunity__c IN :oppIds
            WITH USER_MODE
        ];
    }
}
