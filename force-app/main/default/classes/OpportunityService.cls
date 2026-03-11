public with sharing class OpportunityService {
    

        @AuraEnabled
        public static Id createTrip(Id oppId) {

        Opportunity opp = [
            SELECT Id, AccountId, Destination__c, Start_Date__c, End_Date__c, Number_of_Participants__c, Amount, Days__c
            FROM Opportunity
            WHERE Id = :oppId   
            LIMIT 1
        ];

        String tripName =  opp.Destination__c + ' from ' + opp.Start_Date__c.format() + ' to ' + opp.End_Date__c.format() + ' (' + opp.Days__c + ' jours)';
        Trip__c trip = new Trip__c(
            Name = tripName,
            Opportunity__c = opp.Id,
            Account__c = opp.AccountId,
            Destination__c = opp.Destination__c,
            Start_Date__c = opp.Start_Date__c,
            End_Date__c = opp.End_Date__c,
            Number_of_Participants__c = opp.Number_of_Participants__c
        );

        insert trip;
        return trip.Id;
    }

 }
