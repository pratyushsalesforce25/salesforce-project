@istest
public class OpportunitytriggerHandlertest {
    @istest
    static void afterUpdateOpportunitytest(){
        opportunity opp =new Opportunity();
        opp.name='test opportunity';
        opp.CloseDate=Date.newinstance(2026,10,11);
        opp.StageName='Closed Lost';
        insert Opp;
        
        OpportunityTeamMember opptemember = new OpportunityTeamMember();
        opptemember.UserId=UserInfo.getUserId();
        opptemember.TeamMemberRole='Account Manager';
        opptemember.OpportunityId=opp.id;
        
        insert opptemember;
       
        list<opportunity> opprecord =new list<opportunity>{opp};   
        Test.startTest();
      OpportunityTriggerHandler.afterUpdateOpportunity(opprecord);
        Test.stopTest();
    }
    @istest
    static void afterUpdateOpportunitytest2(){
        opportunity opp =new Opportunity();
        opp.name='test opportunity';
        opp.CloseDate=Date.newinstance(2026,10,11);
        opp.StageName='Closed won';
        opp.OwnerId = UserInfo.getUserId();
        insert Opp;
        
        Task ta =new task();
        Ta.WhatId=opp.Id;
        Ta.Priority='Low';
        Ta.Description='This Task Is Created ';
        Ta.Status='Not Started';
        Ta.Subject='Split revenue';
        Ta.OwnerId=opp.OwnerId;
        insert Ta; 

        list<opportunity> opprecord =new list<opportunity>{opp};   
        Test.startTest();
      OpportunityTriggerHandler.afterUpdateOpportunity(opprecord);
        Test.stopTest();
    }
    @istest
    static void deleteOppCreateTask(){
        
        account acc=new account();
        acc.name='test';
        insert acc;
        
        opportunity opp = new opportunity();
        opp.stagename ='prospecting';
        opp.Name='test opp';
        opp.AccountId=acc.id;
        opp.CloseDate=Date.today().adddays(5);
        insert opp;
        
        list<opportunity> opplist =new list<opportunity>{opp};
            
            Test.StartTest();
        OpportunityTriggerHandler.deleteOppCreateTask(opplist);
        Test.StopTest();
        
    }
}