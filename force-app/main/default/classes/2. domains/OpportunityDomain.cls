public with sharing class OpportunityDomain {

    public static List<Id> validateBeforeUpdate(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap) {

        List<Id> oppIdsToProcess = new List<Id>();

            for (Opportunity newOpp : newMap.values()) {

                Opportunity oldOpp = oldMap.get(newOpp.Id);
                Boolean shouldProcess = newOpp.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won';

                if (shouldProcess) {
                    oppIdsToProcess.add(newOpp.Id);
                }
            }

        return oppIdsToProcess;
    }
}