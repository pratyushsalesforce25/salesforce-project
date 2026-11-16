@isTest
public class ContactTriggerHandlerTest {
@isTest
    static void parentAccountNotNull(){
        account acc =new account();
        acc.name='testing';
         insert acc;
        
        contact con = new contact();
        con.firstname='testing';
        con.AccountId=acc.Id;
        con.lastname='null';
        con.MobilePhone='8245974755';
        con.Email='pratyush@gmail.com';
        insert con;
        list<contact> conlist = new list<contact>{con};    
             Test.startTest();
    ContactTriggerHandler.parentAccountNotNull(conlist);
    Test.stopTest();
    }
    
}