@IsTest
public class AccountTriggerHandlerTest {

    @IsTest
    static void contactWebsiteUpdateTest() {

        Account oldAcc = new Account(
            Name = 'Test Account',
            Website = 'oldwebsite.com'
        );
        insert oldAcc;

        Contact con = new Contact(
            LastName = 'Test Contact',
            AccountId = oldAcc.Id,
            Website__c = 'oldwebsite.com'
        );
        insert con;

        Account newAcc = oldAcc.clone(false, false, false, false);
        newAcc.Id = oldAcc.Id;
        newAcc.Website = 'newwebsite.com';

        List<Account> newList = new List<Account>{newAcc};
        Map<Id, Account> oldMap = new Map<Id, Account>{oldAcc.Id => oldAcc};

        Test.startTest();
        AccountTriggerHandler.contactwebsiteupdate(newList,oldMap);
        Test.stopTest();
    }
      @istest
    static void createnumberofcontacttest(){
        account acc =new account();
        acc.Name='abc';
        acc.Account_N_Contact__c=2;	
        insert acc;
        
        list<account> acclist=new list<account>{acc};
            AccountTriggerHandler.createnumberofcontact(acclist);
    }
    @istest
    static void notchnagedownershiptest(){
        account acc =new account();
        acc.Name='test';
        acc.Industry='Agriculture';
        acc.Type='Prospect';
        acc.Ownership='private';
        insert acc;       

    Account oldAcc = acc.clone(false, true, false, false);
    acc.Ownership = 'Public';

    List<Account> accList = new List<Account>{acc};
    Map<Id, Account> oldMap = new Map<Id, Account>{acc.Id => oldAcc};

    Test.startTest();
    AccountTriggerHandler.notchnagedownership(accList, oldMap);
    Test.stopTest();
    }
}