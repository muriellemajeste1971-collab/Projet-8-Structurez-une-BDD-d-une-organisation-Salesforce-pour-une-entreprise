public with sharing class TripScheduler implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        // Execute the TripProcessor batch with a batch size of 200
        TripProcessor batchJob = new TripProcessor();
        Id batchId = Database.executeBatch(batchJob, 200);
    }
}
