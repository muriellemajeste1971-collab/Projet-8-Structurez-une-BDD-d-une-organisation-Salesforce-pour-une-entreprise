public with sharing class TripStatusProcessor implements Database.Batchable<SObject>, Database.Stateful {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
 
        return Database.getQueryLocator(
            [
            SELECT Id, Name, Status__c, Start_Date__c, End_Date__c, Number_of_Participants__c
            FROM Trip__c
            WHERE Status__c != 'Annulé' AND Status__c != 'Terminé' 
            ]   ); 
    }

    public void execute(Database.BatchableContext bc, List<Trip__c> trips) {
        
        List<Trip__c> tripsToUpdate = new List<Trip__c>();
        Date today = Date.today();

            for (Trip__c t : trips) {  
               
                if (today < t.Start_Date__c) { 
                    t.Status__c = 'A venir';
                } else if (today >= t.Start_Date__c && today <= t.End_Date__c) {
                    t.Status__c = 'En cours';
                } else if (today > t.End_Date__c) {
                    t.Status__c = 'Terminé';
                }
                tripsToUpdate.add(t);      
            } 
        update tripsToUpdate;   
    }

    public void finish(Database.BatchableContext bc) {

    }
}
