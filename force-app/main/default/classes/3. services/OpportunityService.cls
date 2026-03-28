public with sharing class OpportunityService {
    
    @AuraEnabled
    public static List<Trip__c> createTrip(List<Id> oppIds) {

        if (oppIds.isEmpty()) return new List<Trip__c>();

        List<Opportunity> opportunities = OpportunitySelector.selectByIds(oppIds);

        List<Trip__c> trips = TripFactory.assemble(opportunities);
        insert trips;   

        return trips; 
    }      
}
