@istest
public class caseTriggerHandlerTest {
@isTest
    static void sysadmindeletecash(){
      Case ca =new case();
        ca.Status='New';
        ca.Priority='High';
        ca.Origin='Email';
        
        insert ca;
        list<case> caselist = new list<case>{ca};
            Test.StartTest();
        caseTriggerHandler.sysadmindeletecash(caselist);
        Test.StopTest();
    }
}