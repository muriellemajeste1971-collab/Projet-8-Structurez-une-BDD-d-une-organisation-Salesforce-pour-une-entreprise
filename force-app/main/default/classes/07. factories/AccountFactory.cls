public with sharing class AccountFactory {

    public static List<Account> assemble(Integer numberOfAccounts) {

        List<Account> accounts = new List<Account>();

            for (Integer i = 1; i <= numberOfAccounts; i++) {
                
                Account a = new Account( 
                    Name = 'Account ' + i
                );
                accounts.add(a);
            }

        return accounts;
    }
}