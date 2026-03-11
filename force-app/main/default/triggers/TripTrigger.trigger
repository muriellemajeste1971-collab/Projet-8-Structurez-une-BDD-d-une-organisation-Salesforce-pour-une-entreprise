trigger TripTrigger on Trip__c (before insert, before update) {

    if (Trigger.isBefore) {
        for (Trip__c trip : Trigger.new) {
            // Validation : Start Date doit être avant End Date
            if (trip.Start_Date__c != null && trip.End_Date__c != null) {
                if (trip.Start_Date__c > trip.End_Date__c) {
                    trip.addError('La date de début doit être avant la date de fin.');
                }
            }
        }


}
}

