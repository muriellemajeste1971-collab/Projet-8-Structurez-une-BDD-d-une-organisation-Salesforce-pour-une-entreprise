@isTest
private class OpportunitySelectorTest {

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

        //WHEN
        Test.startTest();
        List<Opportunity> result = OpportunitySelector.selectByIds(oppIds);
        Test.stopTest();

        //THEN
        System.assertEquals(1, result.size(), 'One opportunity should have been retrieved');
        System.assertEquals(opportunities[0].Id, result[0].Id, 'Retrieved opportunity has incorrect ID'); 
        System.assertEquals(opportunities[0].Name, result[0].Name, 'Retrieved opportunity has incorrect Name');
        System.assertEquals(opportunities[0].AccountId, result[0].AccountId, 'Retrieved opportunity has incorrect AccountId');
        System.assertEquals(opportunities[0].StageName, result[0].StageName, 'Retrieved opportunity has incorrect StageName');
        System.assertEquals(opportunities[0].Destination__c, result[0].Destination__c, 'Retrieved opportunity has incorrect Destination__c');
        System.assertEquals(opportunities[0].Start_Date__c, result[0].Start_Date__c, 'Retrieved opportunity has incorrect Start_Date__c');
        System.assertEquals(opportunities[0].End_Date__c, result[0].End_Date__c, 'Retrieved opportunity has incorrect End_Date__c');
        System.assertEquals(opportunities[0].Number_of_Participants__c, result[0].Number_of_Participants__c, 'Retrieved opportunity has incorrect Number_of_Participants__c');      
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

        //WHEN
        Test.startTest();
        List<Opportunity> result = OpportunitySelector.selectByIds(oppIds);
        Test.stopTest();

        //THEN
        System.assertEquals(200, result.size(), 'Two hundred opportunities should have been retrieved');
        System.assertEquals(opportunities[0].Id, result[0].Id, 'First retrieved opportunity has incorrect ID');
        System.assertEquals(opportunities[199].Id, result[199].Id, 'Last retrieved opportunity has incorrect ID');
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

        //WHEN
        Test.startTest();
        List<Opportunity> result = OpportunitySelector.selectByIds(oppIds);
        Set<Id> expectedIds = new Set<Id>(oppIds);
        Set<Id> actualIds = new Set<Id>();
            for (Opportunity o : result) {
                actualIds.add(o.Id);
            }
        Test.stopTest();

        //THEN
        System.assertEquals(9, result.size(), 'Nine opportunities should have been retrieved');
        System.assertEquals(expectedIds, actualIds, 'Returned IDs should match inserted IDs');
        System.assertEquals(opportunities[0].StageName, result[0].StageName, 'StageName should match');
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

        // WHEN
        Test.startTest();
        List<Opportunity> result = OpportunitySelector.selectByIds(fakeIds);
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

        List<Id> oppIds = new List<Id>{ opportunities[0].Id };

        // WHEN
        Test.startTest();
        System.runAs(users[0]) {
            try {
                OpportunitySelector.selectByIds(oppIds);
                System.assert(false, 'Une exception aurait dû être levée');
            } catch (Exception e) {
                System.assert(e.getMessage().contains('sObject type \'Opportunity\' is not supported'));
            }
        }
        Test.stopTest();
    }

}