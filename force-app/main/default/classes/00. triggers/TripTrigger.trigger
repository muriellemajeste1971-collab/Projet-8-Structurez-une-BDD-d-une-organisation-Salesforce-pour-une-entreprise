trigger TripTrigger on Trip__c (before insert, before update) {

    TripTriggerHandler.run();

}

