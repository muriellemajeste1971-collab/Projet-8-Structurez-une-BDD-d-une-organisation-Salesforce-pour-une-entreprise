
@isTest
private class TestOpportunityService {

      /**
     * Création d'une livraison avec des données valides
     */
    @IsTest
    static void testcreateTrip() {
        // Given
        Account a = TestDataFactory.createAccount();
        Opportunity opty = TestDataFactory.createOpportunity(a.Id, 'Closed Won');
     	Integer days = opty.Start_Date__c.daysBetween(opty.End_Date__c) + 1; // +1 pour inclure le jour de début
        
       

        // When
        Test.startTest();
        Id tripId = OpportunityService.createTrip(opty.Id);
        Test.stopTest();

        // then
        

        System.assert(tripId != null, 'Le Trip ID ne doit pas être null');
        Trip__c trip = [SELECT Id, Name, Opportunity__c, Account__c, Destination__c, Start_Date__c, End_Date__c, Number_of_Participants__c, Total_Cost__c, Status__c
                             FROM Trip__c 
                             WHERE Id = :tripId];

        
        String tripName =  opty.Destination__c + ' from ' + opty.Start_Date__c.format() + ' to ' + opty.End_Date__c.format() + ' (' + days + ' jours)';
        
        System.assertEquals(opty.Id, trip.Opportunity__c, 'Le trip doit être liée au bon Opportunity');
        System.assertEquals(opty.Destination__c, trip.Destination__c, 'La destination doit être la même que celle de l\'opportunité');
        System.assertEquals(opty.Start_Date__c, trip.Start_Date__c, 'La date de début doit être la même que celle de l\'opportunité');
        System.assertEquals(opty.End_Date__c, trip.End_Date__c, 'La date de fin doit être la même que celle de l\'opportunité');        
        System.assertEquals(a.Id, trip.Account__c, 'Le compte doit être associé');
        System.assertEquals('A venir', trip.Status__c, 'Le statut doit être "A Venir"');
        System.assertEquals(opty.Number_of_Participants__c, trip.Number_of_Participants__c, 'Le nombre de participants doit être le même que celui de l\'opportunité');
		System.assertEquals(tripName, trip.Name, 'Le nom du trip doit être correctement formaté');
    	Integer counttrip = [
        SELECT COUNT() FROM Trip__c WHERE Opportunity__c = :opty.Id
    	];
    	System.assertEquals(1, counttrip, 'Il doit y avoir exactement un trip');
    }
}   