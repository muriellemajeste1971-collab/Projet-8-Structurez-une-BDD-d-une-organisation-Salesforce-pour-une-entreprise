
@isTest
private class TripProcessorTest {

    @isTest
    static void test00_batch() {
        // GIVEN
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
        List<Id> accountIds = new List<Id>();
            for (Account a : accounts) {
                accountIds.add(a.Id);
                }   

        List<Opportunity> opportunities = TestDataFactory.createOpportunities(200, accountIds);
        insert opportunities;   

        List<Id> oppIds = new List<Id>();
            for (Opportunity o : opportunities) {
                oppIds.add(o.Id);
            }
            for (Opportunity o : opportunities) {
                o.StageName = 'Closed Won';
            }
        update opportunities;

        List<Trip__c> trips = TripSelector.selectByOppIds(oppIds);
            for (Trip__c t : trips) {
                t.Start_Date__c= Date.today().addDays(7);
                t.End_Date__c = Date.today().addDays(9);
            }
        update trips;

        //WHEN
        Test.startTest();
            TripProcessor batchJob = new TripProcessor();
            Id batchId = Database.executeBatch(batchJob, 200);
        Test.stopTest();
       

        // THEN
        List<Trip__c> updatedTrips = TripSelector.selectByOppIds(oppIds);
        System.assertEquals(200, updatedTrips.size(), 'Two hundred trips should have been retrieved');
        for (Trip__c t : updatedTrips) {
            System.assertEquals('Annulé', t.Status__c, 'Trip Status__c should have been updated to "Annulé" for past trips');
            System.assertEquals(7, t.Number_of_Participants__c, 'Trip Number_of_Participants__c is less than 10');
            System.assertEquals(Date.today().addDays(7), t.Start_Date__c, 'Trip Start_Date__c should remain unchanged');
        }
    }
}