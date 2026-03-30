
@isTest
private class OpportunityServiceTest {

    @IsTest
    static void test01_singleAction() {

        // GIVEN
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;

        List<Id> accountIds = new List<Id>();
            for (Account a : accounts) {
                accountIds.add(a.Id);
                }
                
        List<Opportunity> opportunities = TestDataFactory.createOpportunities(1, accountIds);
        insert opportunities;

        List<Id> oppIds = new List<Id>();
            for (Opportunity o : opportunities) {
                oppIds.add(o.Id);
            }

            for (Opportunity o : opportunities) {
                o.StageName = 'Closed Won';
            }

        update opportunities;

        //WHEN
        Test.startTest();
        List<Trip__c> result = OpportunityService.createTrips(oppIds);
        Test.stopTest();

        //THEN
        System.assertEquals(1, result.size(), 'One trip should have been retrieved');
        System.assertEquals(opportunities[0].Id, result[0].Opportunity__c, 'Opportunity stage should have been updated to Closed Won');     
        System.assertEquals(accountIds[0], result[0].Account__c, 'Opportunity Account ID should match');
        System.assertEquals(opportunities[0].Destination__c, result[0].Destination__c, 'Trip Destination__c should match');
        System.assertEquals(opportunities[0].Start_Date__c, result[0].Start_Date__c, 'Trip Start_Date__c should match');
        System.assertEquals(opportunities[0].End_Date__c, result[0].End_Date__c, 'Trip End_Date__c should match');
        System.assertEquals(opportunities[0].Number_of_Participants__c, result[0].Number_of_Participants__c, 'Trip Number_of_Participants__c should match');
    }

    @IsTest
    static void test02_bulkActions() {

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

        //WHEN
        Test.startTest();
        List<Trip__c> result = OpportunityService.createTrips(oppIds);
        Test.stopTest();

        //THEN
        System.assertEquals(200, result.size(), 'Two hundred trips should have been retrieved');
            for (Integer i = 0; i < result.size(); i++) {
                System.assertEquals(opportunities[i].Id, result[i].Opportunity__c, 'Opportunity stage should have been updated to Closed Won');     
                System.assertEquals(accountIds[0], result[i].Account__c, 'Opportunity Account ID should match');
                System.assertEquals(opportunities[i].Destination__c, result[i].Destination__c, 'Trip Destination__c should match');
                System.assertEquals(opportunities[i].Start_Date__c, result[i].Start_Date__c, 'Trip Start_Date__c should match');
                System.assertEquals(opportunities[i].End_Date__c, result[i].End_Date__c, 'Trip End_Date__c should match');
                System.assertEquals(opportunities[i].Number_of_Participants__c, result[i].Number_of_Participants__c, 'Trip Number_of_Participants__c should match');
            }
    }
        
       
    @IsTest
    static void test03_positiveBehaviour() {
        
        // GIVEN
        List<Account> accounts = TestDataFactory.createAccounts(3);
        insert accounts;

        List<Id> accountIds = new List<Id>();
            for (Account a : accounts) {
                accountIds.add(a.Id);
                }
                
        List<Opportunity> opportunities = TestDataFactory.createOpportunities(3, accountIds);
        insert opportunities;

        List<Id> oppIds = new List<Id>();
            for (Opportunity o : opportunities) {
                oppIds.add(o.Id);
            }

            for (Opportunity o : opportunities) {
                o.StageName = 'Closed Won';
            }  
        update opportunities;

        //WHEN
        Test.startTest();
        List<Trip__c> result = OpportunityService.createTrips(oppIds);
        Test.stopTest();

        //THEN
        System.assertEquals(9, result.size(), 'Nine trips should have been retrieved');
            for (Integer i = 0; i < result.size(); i++) {
                System.assertEquals(opportunities[i].Id, result[i].Opportunity__c, 'Opportunity stage should have been updated to Closed Won');     
                System.assertEquals(accountIds[i/3], result[i].Account__c, 'Opportunity Account ID should match');
                System.assertEquals(opportunities[i].Destination__c, result[i].Destination__c, 'Trip Destination__c should match');
                System.assertEquals(opportunities[i].Start_Date__c, result[i].Start_Date__c, 'Trip Start_Date__c should match');
                System.assertEquals(opportunities[i].End_Date__c, result[i].End_Date__c, 'Trip End_Date__c should match');
                System.assertEquals(opportunities[i].Number_of_Participants__c, result[i].Number_of_Participants__c, 'Trip Number_of_Participants__c should match');
            }
    }

    @IsTest
    static void test04_negativeBehaviour() {

        // GIVEN
        List<Id> emptyOppIds = new List<Id>();

        // WHEN
        Test.startTest();
        List<Trip__c> result = OpportunityService.createTrips(emptyOppIds);
        Test.stopTest();

        // THEN
        System.assertNotEquals(null, result, 'Result list should not be null');
        System.assertEquals(0, result.size(), 'No trips should be created');

        // Vérification en base
        List<Trip__c> tripsInDb = TripSelector.selectByOppIds(emptyOppIds);
        System.assertEquals(0, tripsInDb.size(), 'No trips should have been inserted');
    }

    @IsTest
    static void test05_retrictedUser() {

        // GIVEN
        List<User> users = TestDataFactory.createUsers(new List<String>{'Chatter Free User'});
        insert users;

        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;

        List<Opportunity> opportunities = TestDataFactory.createOpportunities(1, new List<Id>{accounts[0].Id});
        insert opportunities;

        List<Id> oppIds = new List<Id>();
            for (Opportunity o : opportunities) {
                oppIds.add(o.Id);
            }

            for (Opportunity o : opportunities) {
                o.StageName = 'Closed Won';
            }
        update opportunities;

        // WHEN
        Test.startTest();
        System.runAs(users[0]) {
            try {
                OpportunityService.createTrips(oppIds);
                System.assert(false, 'Une exception aurait dû être levée');
            } catch (Exception e) {
                System.assert(
                    e instanceof System.QueryException,
                    'L’erreur doit être une QueryException'
                );
            }
        }
        Test.stopTest();
    }
       
}

 