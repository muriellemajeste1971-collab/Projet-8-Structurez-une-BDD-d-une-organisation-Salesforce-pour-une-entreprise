@IsTest
private class SalesPermissionTest {

    @IsTest
    static void test00_permission() {
        
        // 1. Créer un utilisateur Sales
        List<User> users = TestDataFactory.createUsers(new List<String>{ 'Sales' });
        insert users;
        User u = users[0];
        

        // 2. Récupérer la permission set créée dans Setup
        PermissionSet ps = [
            SELECT Id FROM PermissionSet WHERE Name = 'TripManagement' LIMIT 1
        ];

        // 3. Assigner la permission à l’utilisateur
        insert new PermissionSetAssignment(
            AssigneeId = u.Id,
            PermissionSetId = ps.Id
        );

        // 4. Tester le comportement sous cet utilisateur
        System.runAs(u) {
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
        
        Test.startTest();
            update opportunities;
        Test.stopTest();

        List<Trip__c> trips = TripSelector.selectByOppIds(oppIds);
        System.assertEquals(1, trips.size(), 'A trip should have been created');
        Trip__c t = trips[0];
        System.assertEquals(opportunities[0].Id, t.Opportunity__c, 'Trip should be linked to the correct Opportunity');
        System.assertEquals(accountIds[0], t.Account__c, 'Trip should be linked to the correct Account');
        System.assertEquals(opportunities[0].Destination__c, t.Destination__c, 'Trip Destination__c should match Opportunity'); 
        System.assertEquals(opportunities[0].Start_Date__c, t.Start_Date__c, 'Trip Start_Date__c should match Opportunity');
        System.assertEquals(opportunities[0].End_Date__c, t.End_Date__c, 'Trip End_Date__c should match Opportunity');
        System.assertEquals(opportunities[0].Number_of_Participants__c, t.Number_of_Participants__c, 'Trip Number_of_Participants__c should match Opportunity');
        }
    }
}