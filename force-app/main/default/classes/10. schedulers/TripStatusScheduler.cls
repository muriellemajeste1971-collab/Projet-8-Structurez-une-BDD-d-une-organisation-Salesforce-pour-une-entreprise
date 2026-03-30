public with sharing class TripStatusScheduler implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        // Execute the TripStatusProcessor batch with a batch size of 200
        TripStatusProcessor batchJob = new TripStatusProcessor();
        Id batchId = Database.executeBatch(batchJob, 200);
    }
}