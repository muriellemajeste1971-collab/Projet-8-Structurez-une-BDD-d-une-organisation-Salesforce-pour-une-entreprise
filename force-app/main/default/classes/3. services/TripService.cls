public with sharing class TripService {

    public static void validateBeforeSave(List<Trip__c> trips) {

        for (Trip__c trip : trips) {

            if (trip.Start_Date__c != null && trip.End_Date__c != null) {
                if (trip.Start_Date__c > trip.End_Date__c) {
                    trip.addError('La date de début doit être avant la date de fin.');
                }
            }
        }
    }
} 