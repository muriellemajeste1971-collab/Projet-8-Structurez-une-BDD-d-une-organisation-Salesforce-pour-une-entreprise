
@isTest
private class TripTriggerTest {

   @IsTest
    static void test01_singleAction_Insert() {
        
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

        //WHEN
        Test.startTest();
        update opportunities;
        Test.stopTest();

        // THEN
        List<Trip__c> trips = TripSelector.selectByOppIds(oppIds);
        System.assertEquals(1, trips.size(), 'One trip should have been created');
        System.assertEquals(opportunities[0].Id, trips[0].Opportunity__c, 'Trip should be linked to the correct Opportunity');
        System.assertEquals(accountIds[0], trips[0].Account__c, 'Trip should be linked to the correct Account');
        System.assertEquals(opportunities[0].Destination__c, trips[0].Destination__c, 'Trip Destination__c should match Opportunity Destination__c');
        System.assertEquals(opportunities[0].Start_Date__c, trips[0].Start_Date__c, 'Trip Start_Date__c should match Opportunity Start_Date__c');
        System.assertEquals(opportunities[0].End_Date__c, trips[0].End_Date__c, 'Trip End_Date__c should match Opportunity End_Date__c');
        System.assertEquals(opportunities[0].Number_of_Participants__c, trips[0].Number_of_Participants__c, 'Trip Number_of_Participants__c should match Opportunity Number_of_Participants__c');
    }

    @isTest
    static void test02_bulkActions_Insert() {

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

        // THEN
        List<Trip__c> trips = TripSelector.selectByOppIds(oppIds);
        System.assertEquals(200, trips.size(), 'Two hundred trips should have been created');
            for (Integer i = 0; i < trips.size(); i++) {
                System.assertEquals(opportunities[i].Id, trips[i].Opportunity__c, 'Trip should be linked to the correct Opportunity');
                System.assertEquals(accountIds[0], trips[i].Account__c, 'Trip should be linked to the correct Account');
                System.assertEquals(opportunities[i].Destination__c, trips[i].Destination__c, 'Trip Destination__c should match Opportunity Destination__c');
                System.assertEquals(opportunities[i].Start_Date__c, trips[i].Start_Date__c, 'Trip Start_Date__c should match Opportunity Start_Date__c');
                System.assertEquals(opportunities[i].End_Date__c, trips[i ].End_Date__c, 'Trip End_Date__c should match Opportunity End_Date__c');
                System.assertEquals(opportunities[i].Number_of_Participants__c, trips[i].Number_of_Participants__c, 'Trip Number_of_Participants__c should match Opportunity Number_of_Participants__c');
            }
    }

    @isTest
    static void test03_positiveBehaviour_Insert() {

        // GIVEN
        List<Account> accounts = TestDataFactory.createAccounts(3);
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

        //WHEN
        Test.startTest();
        update opportunities;
        Test.stopTest();

        // THEN
        List<Trip__c> trips = TripSelector.selectByOppIds(oppIds);
        System.assertEquals(3, trips.size(), 'Three trips should have been created');
            for (Integer i = 0; i < trips.size(); i++) {
                System.assertEquals(opportunities[i].Id, trips[i].Opportunity__c, 'Trip should be linked to the correct Opportunity');
                System.assertEquals(accountIds[i], trips[i].Account__c, 'Trip should be linked to the correct Account');
                System.assertEquals(opportunities[i].Destination__c, trips[i].Destination__c, 'Trip Destination__c should match Opportunity Destination__c');
                System.assertEquals(opportunities[i].Start_Date__c, trips[i].Start_Date__c, 'Trip Start_Date__c should match Opportunity Start_Date__c');
                System.assertEquals(opportunities[i].End_Date__c, trips[i ].End_Date__c, 'Trip End_Date__c should match Opportunity End_Date__c');
                System.assertEquals(opportunities[i].Number_of_Participants__c, trips[i].Number_of_Participants__c, 'Trip Number_of_Participants__c should match Opportunity Number_of_Participants__c');
            }
    }

    @isTest
    static void test04_negativeBehaviour_Insert() {

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
                o.Start_Date__c = Date.today().addDays(10);
                o.End_Date__c = Date.today();
            }

        //WHEN
          try {
            Test.startTest();
            update opportunities;
            Test.stopTest();
            System.assert(false, 'Une erreur aurait dû être levée');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('La date de début doit être avant la date de fin.'));
        }  
    }

    @isTest
    static void test05_restrictedUser_Insert() {
        // GIVEN
        List<User> users = TestDataFactory.createUsers(new List<String>{'Chatter Free User'});
        insert users;

        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
        List<Id> accountIds = new List<Id>();
            for (Account a : accounts) {
                accountIds.add(a.Id);
                }

        List<Opportunity> opportunities = TestDataFactory.createOpportunities(1, new List<Id>{accounts[0].Id});
        insert opportunities;

        List<Id> oppIds = new List<Id>();
            for (Opportunity o : opportunities) {
                oppIds.add(o.Id);
            }

            for (Opportunity o : opportunities) {
                o.StageName = 'Closed Won';
            }
        
        // WHEN
        Test.startTest();
        System.runAs(users[0]) {
            try {
                update opportunities;
                System.assert(false, 'Une exception aurait dû être levée');
            } catch (Exception e) {
                System.assert(
                    e instanceof System.DmlException,
                    'L’erreur doit être une DmlException'
                );
            }
        }
        Test.stopTest();
    }

     @IsTest
    static void test11_singleAction_Update() {
        
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

        List<Trip__c> trips = TripSelector.selectByOppIds(oppIds);
            for (Trip__c t : trips) {
                t.Start_Date__c= Date.today();
                t.End_Date__c = Date.today().addDays(4);
            }

        //WHEN
        Test.startTest();
        update trips;
        Test.stopTest();

        // THEN
        System.assertEquals(1, trips.size(), 'One trip should have been created');
        System.assertEquals(opportunities[0].Id, trips[0].Opportunity__c, 'Trip should be linked to the correct Opportunity');
        System.assertEquals(accountIds[0], trips[0].Account__c, 'Trip should be linked to the correct Account');
        System.assertEquals(opportunities[0].Destination__c, trips[0].Destination__c, 'Trip Destination__c should match Opportunity Destination__c');
        System.assertEquals(Date.today(), trips[0].Start_Date__c, 'Trip Start_Date__c should match Opportunity Start_Date__c');
        System.assertEquals(Date.today().addDays(4), trips[0].End_Date__c, 'Trip End_Date__c should match Opportunity End_Date__c');
        System.assertEquals(opportunities[0].Number_of_Participants__c, trips[0].Number_of_Participants__c, 'Trip Number_of_Participants__c should match Opportunity Number_of_Participants__c');
    }

    @isTest
    static void test12_bulkActions_Update() {

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
                t.Start_Date__c= Date.today();
                t.End_Date__c = Date.today().addDays(4);
            }

        //WHEN
        Test.startTest();
        update trips;
        Test.stopTest();

        // THEN
        System.assertEquals(200, trips.size(), 'Two hundred trips should have been created');
            for (Integer i = 0; i < trips.size(); i++) {
                System.assertEquals(opportunities[i].Id, trips[i].Opportunity__c, 'Trip should be linked to the correct Opportunity');
                System.assertEquals(accountIds[0], trips[i].Account__c, 'Trip should be linked to the correct Account');
                System.assertEquals(opportunities[i].Destination__c, trips[i].Destination__c, 'Trip Destination__c should match Opportunity Destination__c');
                System.assertEquals(Date.today(), trips[i].Start_Date__c, 'Trip Start_Date__c should match Opportunity Start_Date__c');
                System.assertEquals(Date.today().addDays(4), trips[i ].End_Date__c, 'Trip End_Date__c should match Opportunity End_Date__c');
                System.assertEquals(opportunities[i].Number_of_Participants__c, trips[i].Number_of_Participants__c, 'Trip Number_of_Participants__c should match Opportunity Number_of_Participants__c');
            }
    }

    @isTest
    static void test13_positiveBehaviour_Update() {

        // GIVEN
        List<Account> accounts = TestDataFactory.createAccounts(3);
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

        List<Trip__c> trips = TripSelector.selectByOppIds(oppIds);
            for (Trip__c t : trips) {
                t.Start_Date__c= Date.today();
                t.End_Date__c = Date.today().addDays(4);
            }

        //WHEN
        Test.startTest();
        update trips;
        Test.stopTest();

        // THEN
        System.assertEquals(3, trips.size(), 'Three trips should have been created');
            for (Integer i = 0; i < trips.size(); i++) {
                System.assertEquals(opportunities[i].Id, trips[i].Opportunity__c, 'Trip should be linked to the correct Opportunity');
                System.assertEquals(accountIds[i], trips[i].Account__c, 'Trip should be linked to the correct Account');
                System.assertEquals(opportunities[i].Destination__c, trips[i].Destination__c, 'Trip Destination__c should match Opportunity Destination__c');
                System.assertEquals(Date.today(), trips[i].Start_Date__c, 'Trip Start_Date__c should match Opportunity Start_Date__c');
                System.assertEquals(Date.today().addDays(4), trips[i ].End_Date__c, 'Trip End_Date__c should match Opportunity End_Date__c');
                System.assertEquals(opportunities[i].Number_of_Participants__c, trips[i].Number_of_Participants__c, 'Trip Number_of_Participants__c should match Opportunity Number_of_Participants__c');
            }
    }

    @isTest
    static void test14_negativeBehaviour_Update() {

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

        List<Trip__c> trips = TripSelector.selectByOppIds(oppIds);
            for (Trip__c t : trips) {
                t.Start_Date__c= Date.today().addDays(10);
                t.End_Date__c = Date.today();
            }

        //WHEN
          try {
            Test.startTest();
            update trips;
            Test.stopTest();
            System.assert(false, 'Une erreur aurait dû être levée');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('La date de début doit être avant la date de fin.'));
        }  
    }

    @isTest
    static void test15_restrictedUser_Update() {
        // GIVEN
        List<User> users = TestDataFactory.createUsers(new List<String>{'Chatter Free User'});
        insert users;

        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
        List<Id> accountIds = new List<Id>();
            for (Account a : accounts) {
                accountIds.add(a.Id);
                }

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

        List<Trip__c> trips = TripSelector.selectByOppIds(oppIds);
            for (Trip__c t : trips) {
                t.Start_Date__c= Date.today().addDays(10);
                t.End_Date__c = Date.today();
            }
        
        // WHEN
        Test.startTest();
        System.runAs(users[0]) {
            try {
                update trips;
                System.assert(false, 'Une exception aurait dû être levée');
            } catch (Exception e) {
                System.assert(
                    e instanceof System.DmlException,
                    'L’erreur doit être une DmlException'
                );
            }
        }
        Test.stopTest();
    }
}

