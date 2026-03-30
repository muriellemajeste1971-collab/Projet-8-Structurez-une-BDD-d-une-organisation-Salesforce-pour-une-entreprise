public with sharing class OpportunityTriggerHandler {
    
    public static void run() {

        if (Trigger.isAfter && Trigger.isUpdate) {

            List<Id> oppIds = OpportunityDomain.validateBeforeUpdate(
                (Map<Id, Opportunity>) Trigger.oldMap,
                (Map<Id, Opportunity>) Trigger.newMap
            );

            OpportunityService.createTrips(oppIds);
        }
    }
}
