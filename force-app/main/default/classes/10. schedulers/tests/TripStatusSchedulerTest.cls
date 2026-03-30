@isTest
private with sharing class TripStatusSchedulerTest {

    @isTest
    static void test00_schedule() {

        // GIVEN
        List<Account> accounts = TestDataFactory.createAccounts(3);
        insert accounts;

        List<Opportunity> opportunities = TestDataFactory.createOpportunities(60, new List<Id>{
            accounts[0].Id, accounts[1].Id, accounts[2].Id
        });
        insert opportunities;

        for (Opportunity o : opportunities) {
            o.StageName = 'Closed Won';
        }
        update opportunities;

        List<Id> oppIds = new List<Id>();
        for (Opportunity o : opportunities) oppIds.add(o.Id);

        List<Trip__c> trips = TripSelector.selectByOppIds(oppIds);

        for (Trip__c t : trips) {
            if (t.Account__c == accounts[0].Id) {
                t.Start_Date__c = Date.today().addDays(10);   // A venir
                t.End_Date__c   = Date.today().addDays(19);
            }
            else if (t.Account__c == accounts[1].Id) {
                t.Start_Date__c = Date.today().addDays(-5);   // En cours
                t.End_Date__c   = Date.today().addDays(14);
            }
            else if (t.Account__c == accounts[2].Id) {
                t.Start_Date__c = Date.today().addDays(-20);  // Terminé
                t.End_Date__c   = Date.today().addDays(-5);
            }
        }
        update trips;

        // WHEN
        Test.startTest();
            new TripStatusScheduler().execute(null);
        Test.stopTest();

        // THEN
        List<Trip__c> updatedTrips = TripSelector.selectByOppIds(oppIds);
        System.assertEquals(180, updatedTrips.size());

            // Regroupement par compte pour des asserts fiables
            Map<Id, List<Trip__c>> grouped = new Map<Id, List<Trip__c>>();
            for (Trip__c t : updatedTrips) {
                if (!grouped.containsKey(t.Account__c)) {
                    grouped.put(t.Account__c, new List<Trip__c>());
                }
                grouped.get(t.Account__c).add(t);
            }

            // A venir
            for (Trip__c t : grouped.get(accounts[0].Id)) {
                System.assertEquals('A venir', t.Status__c);
            }

            // En cours
            for (Trip__c t : grouped.get(accounts[1].Id)) {
                System.assertEquals('En cours', t.Status__c);
            }

            // Terminé
            for (Trip__c t : grouped.get(accounts[2].Id)) {
                System.assertEquals('Terminé', t.Status__c);
            }
    }
}
