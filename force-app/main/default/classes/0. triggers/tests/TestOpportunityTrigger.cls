
@isTest
private class TestOpportunityTrigger {



     @IsTest
    static void testAfterUpdate() {
           // Given
        Account a = TestDataFactory.createAccount();
        Opportunity opty = TestDataFactory.createOpportunity(a.Id, 'Prospecting');
        

        // Test
        Test.startTest();
        opty.StageName = 'Closed Won';
        update opty;
        Test.stopTest();

       Trip__c trip = [
                    SELECT Id, Name, Opportunity__c, Account__c, Destination__c, Start_Date__c, End_Date__c, Number_of_Participants__c, Total_Cost__c, Status__c
                    FROM Trip__c 
                    WHERE Opportunity__c = :opty.Id
                    
                ];

        System.assertEquals(true, trip != null, 'Le trip doit exister après la mise à jour de l\'opportunité');


    }

}