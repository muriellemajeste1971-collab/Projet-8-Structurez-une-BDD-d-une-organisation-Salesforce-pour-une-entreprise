trigger OpportunityTrigger on Opportunity (after update) {

    // --- AFTER UPDATE ---
    if ( Trigger.isUpdate) {

        List<Id> oppIdsToProcess = new List<Id>();

        for (Opportunity opp : Trigger.new) {

            String stage = opp.StageName;

            Boolean ShouldProcess = (stage == 'Closed Won' && Trigger.oldMap.get(opp.Id).StageName != 'Closed Won');
            if (ShouldProcess) oppIdsToProcess.add(opp.Id);
        }

       
        // appel orchestrateur uniquement pour les orders éligibles
        for (Id oppId : oppIdsToProcess) {
            OpportunityService.createTrip(oppId);
        }
    }

    
}