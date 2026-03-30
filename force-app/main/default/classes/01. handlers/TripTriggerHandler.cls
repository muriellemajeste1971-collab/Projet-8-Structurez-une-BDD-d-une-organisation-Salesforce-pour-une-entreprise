public with sharing class TripTriggerHandler {

    public static void run() {

        if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {

            TripService.validateBeforeSave((List<Trip__c>) Trigger.new);
        }
    }
}
