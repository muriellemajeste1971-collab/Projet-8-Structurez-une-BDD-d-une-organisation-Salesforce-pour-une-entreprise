@isTest
private with sharing class TripSchedulerTest {

    @isTest
    static void test00_schedule() {

        // GIVEN
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;

        List<Opportunity> opportunities = TestDataFactory.createOpportunities(200, new List<Id>{ accounts[0].Id });
        insert opportunities;

        for (Opportunity o : opportunities) {
            o.StageName = 'Closed Won';
        }
        update opportunities;

        List<Id> oppIds = new List<Id>();
        for (Opportunity o : opportunities) oppIds.add(o.Id);

        List<Trip__c> trips = TripSelector.selectByOppIds(oppIds);
        for (Trip__c t : trips) {
            t.Start_Date__c = Date.today().addDays(7);
            t.End_Date__c   = Date.today().addDays(9);
            t.Number_of_Participants__c = 7;
        }
        update trips;

        // WHEN
        Test.startTest();
            new TripScheduler().execute(null);
        Test.stopTest();

        // THEN
        List<Trip__c> updatedTrips = TripSelector.selectByOppIds(oppIds);

        System.assertEquals(200, updatedTrips.size());

        for (Trip__c t : updatedTrips) {
            System.assertEquals('Annulé', t.Status__c);
            System.assertEquals(7, t.Number_of_Participants__c);
            System.assertEquals(Date.today().addDays(7), t.Start_Date__c);
        }
    }
}
