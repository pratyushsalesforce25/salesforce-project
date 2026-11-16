public class OpportunityTriggerHandler {
    
    public static void updateAmount(list<opportunity>opplist,map<id,opportunity> oldMap){
        
        for(opportunity opp:opplist){
            Opportunity oldOpp = oldMap.get(opp.Id);
            if(oldOpp != null && oldOpp.StageName != opp.StageName){
                opp.Amount=opp.ExpectedRevenue * opp.Probability;
            }
        }
    }
    
    Public static void afterUpdateOpportunity(List<opportunity> opprecord){
        set<id> opportunityIds = new set<id>();
        for(opportunity oppre : opprecord){
            opportunityIds.add(oppre.Id);
        }
        list<OpportunityTeamMember> deleteoppmemberlist = new list<OpportunityTeamMember>();
        list<Task> createTask = new list<Task>();
        
        list<OpportunityTeamMember> oppTeamMember =[select id,opportunityId from OpportunityTeamMember Where OpportunityId In:opportunityids ];
        For(Opportunity Opp:opprecord){
            if(opp.StageName =='Closed Won'){
                Task Ta=New Task();
                Ta.OwnerId=opp.OwnerId;
                Ta.WhatId=opp.Id;
                Ta.Priority='Low';
                Ta.Description='This Task Is Created ';
                Ta.Status='Not Started';
                Ta.Subject='Split revenue';
                
                createTask.add(ta);  
            }
            else if(opp.StageName == 'Closed Lost'){
                for(OpportunityTeamMember oppmember:oppTeamMember){
                    if(oppmember.opportunityId == opp.Id){
                        deleteoppmemberlist.add(oppmember);
                    }
                } 
            }
        }
        if(!createTask.isEmpty()){
            Insert createtask;
        }
            if(!deleteoppmemberlist.isEmpty()){
                delete deleteoppmemberlist;
            
        }
    }
    
    public static void deleteOppCreateTask(list<opportunity> opplist){
        list<task> tasklist =new list<task>();
        set<id>accountids =new set<id>();
        
        for(opportunity opp:opplist){
            if(opp.AccountId != null){
                accountids.add(opp.AccountId);
            }
        }
        Map<id,Account>accmap =new Map<id,Account>([select Id,ownerId From Account where id In:accountids]);
        for(opportunity opp :opplist){
            
            if(accmap.containsKey(opp.AccountId) && opp.AccountId != null){
                Account relatedAccount = accmap.get(opp.AccountId);
                Task newtask =new task();
                newTask.Subject = 'Investigate Deleted Opportunity: ' + opp.Name;
                newTask.Description = 'The Opportunity "' + opp.Name + '" was deleted on ' + Date.today().format() + '. Please verify the account.';
                newTask.Priority = 'Normal';
                newTask.Status = 'Not Started';
                newTask.ActivityDate = Date.today().addDays(7); 
                newTask.WhatId = relatedAccount.Id;             
                newTask.OwnerId = relatedAccount.OwnerId;
                tasklist.add(newtask);
            }
            if(!tasklist.isEmpty()){
                insert tasklist;
            }
        }
    }
}