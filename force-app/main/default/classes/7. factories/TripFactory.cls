public with sharing class TripFactory {

    public static List<Trip__c> assemble(List<Opportunity> opportunities) {

        List<Trip__c> trips = new List<Trip__c>();

            for(Opportunity o : opportunities) {

                String tripName =  
                    o.Destination__c + ' from ' + 
                    o.Start_Date__c.format() + ' to ' + 
                    o.End_Date__c.format() + ' (' + 
                    o.Days__c + ' jours)';
                    
                Trip__c trip = new Trip__c(
                    Name = tripName,
                    Opportunity__c = o.Id,
                    Account__c = o.AccountId,
                    Destination__c = o.Destination__c,
                    Start_Date__c = o.Start_Date__c,
                    End_Date__c = o.End_Date__c,
                    Number_of_Participants__c = o.Number_of_Participants__c
                );
                trips.add(trip);
            }
        return trips;
    }
}