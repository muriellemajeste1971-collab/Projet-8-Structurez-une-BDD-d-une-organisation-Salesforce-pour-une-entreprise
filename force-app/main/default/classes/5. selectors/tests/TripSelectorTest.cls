
@isTest
private class TripSelectorTest {

    @isTest
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
        List<Trip__c> result = TripSelector.selectByOppIds(oppIds);
        Test.stopTest();

        //THEN
        System.assertEquals(1, result.size(), 'One trip should have been retrieved');
        System.assertEquals(opportunities[0].Id, result[0].Opportunity__c, 'Retrieved trip has incorrect ID'); 
        System.assertNotEquals(null, result[0].Name, 'Retrieved trip has incorrect Name');
        System.assertEquals(opportunities[0].AccountId, result[0].Account__c, 'Retrieved trip has incorrect AccountId');
        System.assertEquals(opportunities[0].Destination__c, result[0].Destination__c, 'Retrieved trip has incorrect Destination__c');
        System.assertEquals(opportunities[0].Start_Date__c, result[0].Start_Date__c, 'Retrieved trip has incorrect Start_Date__c');
        System.assertEquals(opportunities[0].End_Date__c, result[0].End_Date__c, 'Retrieved trip has incorrect End_Date__c');
        System.assertEquals(opportunities[0].Number_of_Participants__c, result[0].Number_of_Participants__c, 'Retrieved trip has incorrect Number_of_Participants__c');      
    }

    @isTest
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
        List<Trip__c> result = TripSelector.selectByOppIds(oppIds);
        Test.stopTest();

        //THEN
        System.assertEquals(200, result.size(), 'Two hundred opportunities should have been retrieved');
            for (Integer i = 0; i < result.size(); i++) {
                System.assertEquals(opportunities[i].Id, result[i].Opportunity__c, 'Retrieved trip has incorrect ID at index ' + i);
                System.assertEquals(opportunities[i].AccountId, result[i].Account__c, 'Retrieved trip has incorrect AccountId at index ' + i);
            }
    }

    @isTest
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
        List<Trip__c> result = TripSelector.selectByOppIds(oppIds);
        Test.stopTest();

        //THEN
        System.assertEquals(9, result.size(), 'Nine opportunities should have been retrieved');
            for (Integer i = 0; i < result.size(); i++) {
                System.assertEquals(opportunities[i].Id, result[i].Opportunity__c, 'Retrieved trip has incorrect ID at index ' + i);
                System.assertEquals(opportunities[i].AccountId, result[i].Account__c, 'Retrieved trip has incorrect AccountId at index ' + i);
            }
    }

    @isTest
    static void test04_negativeBehaviour() {

        // GIVEN
        // Liste d'IDs qui ne correspondent à aucune Opportunity insérée
        List<Id> fakeIds = new List<Id>{
            '006000000000001AAA',
            '006000000000002AAA',
            '006000000000003AAA'
        };

        List<Trip__c> trips = OpportunityService.createTrips(fakeIds);

        // WHEN
        Test.startTest();
        List<Trip__c> result = TripSelector.selectByOppIds(fakeIds);
        Test.stopTest();

        // THEN
        System.assertNotEquals(null, result, 'Result list should not be null');
        System.assertEquals(0, result.size(), 'No opportunities should have been retrieved');
    }

    @isTest
    static void test05_restrictedUser() {

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
                TripSelector.selectByOppIds(oppIds);
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