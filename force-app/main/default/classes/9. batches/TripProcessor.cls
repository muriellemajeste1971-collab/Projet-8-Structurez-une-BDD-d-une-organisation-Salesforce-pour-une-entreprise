public with sharing class TripProcessor implements Database.Batchable<SObject>, Database.Stateful {

    public Database.QueryLocator start(Database.BatchableContext bc) {
 
        return Database.getQueryLocator([
            SELECT Id, Name, Status__c, Start_Date__c, End_Date__c, Number_of_Participants__c
            FROM Trip__c
            WHERE Start_Date__c = :Date.today().addDays(7) AND Number_of_Participants__c < 10 AND Status__c != 'Annulé'
        ]); 
    }

    public void execute(Database.BatchableContext bc, List<Trip__c> trips) {
        
        List<Trip__c> tripsToUpdate = new List<Trip__c>();

            for (Trip__c t : trips) {  
               
                t.Status__c = 'Annulé';
                tripsToUpdate.add(t);    
                
            }
            
        update tripsToUpdate;
        
    }

    public void finish(Database.BatchableContext bc) {

    }
}