public without sharing class AccountContactController {
    
    @AuraEnabled(cacheable=false)
    public static String createAccountContact(
        String accName, 
        String accPhone, 
        String firstName, 
        String lastName, 
        String mobile
    ) {
        Savepoint sp = Database.setSavepoint();
        
        try {
           
            Account acc = new Account(
                Name = accName,
                Phone = accPhone
            );
            insert acc;
         
            Contact con = new Contact(
                FirstName = firstName,
                LastName = lastName,
                MobilePhone = mobile,
                AccountId = acc.Id
            );
            insert con;
           reassignOwnership(acc.Id, con.Id);
            
            return acc.Name;
            
        } catch (Exception e) {
            Database.rollback(sp);
            throw new AuraHandledException('Error: ' + e.getMessage());
        }
    }
    
    @future
    private static void reassignOwnership(Id accountId, Id contactId) {
       
        User adminUser = [SELECT Id FROM User WHERE Profile.Name LIKE '%Admin%' AND IsActive = TRUE LIMIT 1];
        
        Account acc = new Account(Id = accountId, OwnerId = adminUser.Id);
        Contact con = new Contact(Id = contactId, OwnerId = adminUser.Id);
        
        update acc;
        update con;
    }
}