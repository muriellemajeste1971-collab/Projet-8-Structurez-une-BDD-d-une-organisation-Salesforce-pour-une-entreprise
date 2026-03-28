
@isTest
private class TestTripTrigger {

   @IsTest
    static void testBeforeInsert_InvalidDates() {
           // Given
        Trip__c trip = new Trip__c(
            Name = 'Test Trip',
            Start_Date__c = Date.today().addDays(10),
            End_Date__c = Date.today().addDays(5) // End Date avant Start Date pour déclencher l'erreur
        );
      // When + Then : on vérifie que l'insert lève une erreur
        try {
            insert trip;
            System.assert(false, 'L\'insert aurait dû échouer à cause des dates invalides');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('La date de début doit être avant la date de fin'),
                'Le message d\'erreur doit indiquer que les dates sont incohérentes'
            );
        }

    }

        @isTest
    static void testBeforeUpdate_InvalidDates() {

        // 1. Trip valide
        Trip__c trip = new Trip__c(
            Name = 'Trip Valide',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(5)
        );
        insert trip;

        // 2. On rend les dates invalides
        trip.End_Date__c = Date.today().addDays(-1);

        try {
            update trip;
            System.assert(false, 'L\'update aurait dû échouer à cause des dates invalides');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('La date de début doit être avant la date de fin'),
                'Le message d\'erreur doit indiquer que les dates sont incohérentes'
            );
        }
    }
}

