public with sharing class OpportunitySelector {

    public static List<Opportunity> selectByIds(List<Id> oppIds) {

        return [
            SELECT Id, AccountId, Destination__c, Start_Date__c, End_Date__c, Number_of_Participants__c, Amount, Days__c
            FROM Opportunity
            WHERE Id IN :oppIds
            WITH USER_MODE
        ];
    }
}