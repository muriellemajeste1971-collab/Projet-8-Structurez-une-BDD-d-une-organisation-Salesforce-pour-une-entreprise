@isTest
public class TestDataFactory {

    // Create dummy users for Unit Tests
    public static List<User> createUsers(List<String> profileNames) {

        List<Profile> profiles = ProfileFactory.assemble(profileNames); 
        List<User> users = UserFactory.assemble(profiles); 
        return users; 
    }
    
    // Create dummy accounts for unit tests
    public static List<Account> createAccounts(Integer numberOfAcounts ) {
        
        List<Account> accounts = AccountFactory.assemble(numberOfAcounts);
        return accounts;
    }

    // Create dummy opportunities for unit tests
    public static List<Opportunity> createOpportunities(Integer numberOfOpportunities, List<Id> accountIds) { 

        List<Opportunity> opportunities = OpportunityFactory.assemble(numberOfOpportunities, accountIds);
        return opportunities;
    }

    public static List<Trip__c> createTrips(List<Opportunity> opportunities) {
        List<Trip__c> trips = TripFactory.assemble(opportunities);
        return trips;
       
    }


    public static Order createOrder(Id accountId, Id contractId) {
	// 1. Récupération du standard pricebook
   		Id pbId = Test.getStandardPricebookId();

        
    // 2. Création de la commande
    	Order o = new Order(
        					Name = 'Order 1 for Account 1',
        					AccountId = accountId,
        					ContractId = contractId,
            				Pricebook2Id = pbId,
        					Status = 'Draft',
        					ShippingCountry = 'FR',
        					EffectiveDate = Date.today()
    						);
    	insert o;

   

    // 3. création des bijoux
	     Product2 p1 = new Product2(
            Name = 'Bijoux 1',
            ProductCode = 'BJ01',
            IsActive = true
        );
        insert p1;
        
         Product2 p2 = new Product2(
            Name = 'Bijoux 2',
            ProductCode = 'BJ02',
            IsActive = true
        );
		insert p2;
        
         Product2 p3 = new Product2(
            Name = 'Bijoux 3',
            ProductCode = 'BJ03',
            IsActive = true
        );
        insert p3;
        
       // 4. création des bijoux
        
       PricebookEntry e1 = new PricebookEntry(
            Pricebook2Id = pbId,
            Product2Id = p1.Id,
            UnitPrice = 10000,
            IsActive = true
        );
        insert e1;
        
    	PricebookEntry e2 = new PricebookEntry(
            Pricebook2Id = pbId,
            Product2Id = p2.Id,
            UnitPrice = 20000,
            IsActive = true
        );
        insert e2;

     	PricebookEntry e3 = new PricebookEntry(
            Pricebook2Id = pbId,
            Product2Id = p3.Id,
            UnitPrice = 30000,
            IsActive = true
        );
        insert e3;
    

    // 4. Création des OrderItems
       OrderItem oi1 = new OrderItem(
            OrderId = o.Id,
            PricebookEntryId = e1.Id,
            Product2Id = p1.Id,
            Quantity = 2,
            UnitPrice = 10000
        );
        insert oi1;

 		OrderItem oi2 = new OrderItem(
            OrderId = o.Id,
            PricebookEntryId = e2.Id,
            Product2Id = p2.Id,
            Quantity = 1,
            UnitPrice = 20000
        );
        insert oi2;
        
        OrderItem oi3 = new OrderItem(
            OrderId = o.Id,
            PricebookEntryId = e3.Id,
            Product2Id = p3.Id,
            Quantity = 1,
            UnitPrice = 30000
        );
        insert oi3;
        
        
    // 5. Activation de la commande
    o.Status = 'Activated';
    o.ActivatedDate = Date.today();
    update o;

    return o;
}

    
  
    
    
    

}