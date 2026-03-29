
@isTest
private class OpportunityDomainTest {

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

        opportunities[0].StageName = 'Closed Won';

        //WHEN
        Test.startTest();
        update opportunities;
        Test.stopTest();

        //THEN
        List<Opportunity> updatedOpps = OpportunitySelector.selectByIds(oppIds);
        System.assertEquals(1, updatedOpps.size(), 'One opportunity should have been retrieved');
        System.assertEquals('Closed Won', updatedOpps[0].StageName, 'Opportunity stage should have been updated to Closed Won');    
        System.assertEquals(6, updatedOpps[0].Days__c, 'Days__c field should have been calculated');  
        System.assertEquals(accountIds[0], updatedOpps[0].AccountId, 'Opportunity Account ID should match');
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

        //WHEN
        Test.startTest();
        update opportunities;
        Test.stopTest();

        //THEN
        List<Opportunity> updatedOpps = OpportunitySelector.selectByIds(oppIds);
        System.assertEquals(200, updatedOpps.size(), 'All opportunities should have been retrieved');

        System.assertEquals('Closed Won', updatedOpps[0].StageName, 'Opportunity stage should have been updated to Closed Won');    
        System.assertEquals(6, updatedOpps[0].Days__c, 'Days__c field should have been calculated'); 
        System.assertEquals(accountIds[0], updatedOpps[0].AccountId, 'Opportunity Account ID should match');
        System.assertEquals('Closed Won', updatedOpps[199].StageName, 'Opportunity stage should have been updated to Closed Won');    
        System.assertEquals(6, updatedOpps[199].Days__c, 'Days__c field should have been calculated');
        System.assertEquals(accountIds[0], updatedOpps[199].AccountId, 'Opportunity Account ID should match');
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

        //WHEN
        Test.startTest();
        update opportunities;
        Test.stopTest();

        //THEN
        List<Opportunity> updatedOpps = OpportunitySelector.selectByIds(oppIds);
        System.assertEquals(9, updatedOpps.size(), 'Nine opportunities should have been retrieved');

            for (Integer i = 0; i < 9; i++) {
                System.assertEquals('Closed Won', updatedOpps[i].StageName, 'Opportunity stage should have been updated to Closed Won');    
                System.assertEquals(6, updatedOpps[i].Days__c, 'Days__c field should have been calculated');  
                System.assertEquals(accountIds[i/3], updatedOpps[i].AccountId, 'Opportunity Account ID should match');
            }
    }

    @isTest
    static void test04_negativeBehaviour() {
        
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
                o.StageName = 'Closed Lost';
                o.Start_Date__c = Date.today().addDays(5);
                o.End_Date__c = Date.today();
            }

        //WHEN
        Test.startTest();
        update opportunities;
        Test.stopTest();

        //THEN
        List<Opportunity> updatedOpps = OpportunitySelector.selectByIds(oppIds);
        System.assertEquals(1, updatedOpps.size(), 'One opportunity should have been retrieved');
        System.assertEquals('Closed Lost', updatedOpps[0].StageName, 'Opportunity stage should have been updated to Closed Lost instead of Closed Won');    
        System.assertEquals(opportunities[0].Start_Date__c, updatedOpps[0].Start_Date__c, 'Start date should remain unchanged');
        System.assertEquals(opportunities[0].End_Date__c, updatedOpps[0].End_Date__c, 'End date should remain unchanged');
        System.assertEquals(accountIds[0], updatedOpps[0].AccountId, 'Opportunity Account ID should match');
    }

    @isTest
    static void test06_emptyList() {

        // GIVEN
        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>();
        Map<Id, Opportunity> newMap = new Map<Id, Opportunity>();

        // WHEN
        Test.startTest();
        OpportunityDomain.validateBeforeUpdate(oldMap, newMap);
        Test.stopTest();

        // THEN
        System.assert(true, 'Domain should not fail on empty list');
    }
    @isTest
    static void test07_nullList() {

        // GIVEN
        Map<Id, Opportunity> oldMap = null;
        Map<Id, Opportunity> newMap = null;

        // WHEN
        Test.startTest();
        OpportunityDomain.validateBeforeUpdate(oldMap, newMap);
        Test.stopTest();

        // THEN
        System.assert(true, 'Domain should not fail on null maps');
    }
}