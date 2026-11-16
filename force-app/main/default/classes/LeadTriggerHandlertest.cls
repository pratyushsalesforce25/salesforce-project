@istest
public class LeadTriggerHandlertest {
    @istest
    static void InsertTaskTest(){
        User u = [SELECT Id FROM User WHERE Alias = 'pra' LIMIT 1];
        lead le = new lead(LastName='test',Company='test company',OwnerId=u.id);
        insert le;
        
        Task Ta=New Task();
        Ta.OwnerId=le.OwnerId;
        Ta.WhoId=le.Id;
        Ta.Priority='High';
        Ta.Description='This Task Is Created';
        Ta.Status='Not Started';
        Ta.Subject='Split Lead ';
        
        insert Ta;
        List<Lead> leadList = new List<Lead>{le};
            
            Test.startTest();
        LeadTriggerhandler.InsertTask(leadList);
        Test.StopTest();
    }  
    @istest
    static void leaddelete(){
        lead le = new lead();
        le.LastName='abc';
        le.Status='Working - Contacted';
        le.Company='testing';
        insert le;
        
        list<lead> leadlist=new list<lead>{le};
            
           Test.startTest();
        LeadTriggerhandler.notdeletestatusWorking(leadlist);
        Test.StopTest();
    }
    
     @isTest
    static void testLeadRatingUpdate() {

        Lead le = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            LeadSource = 'Phone Inquiry'
        );
        insert le;

        le.LeadSource = 'web';

        Test.startTest();
        update le;
        Test.stopTest();
    }
}