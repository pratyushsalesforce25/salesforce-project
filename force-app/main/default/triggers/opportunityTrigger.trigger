trigger opportunityTrigger on Opportunity (Before update,After Update,after delete) {
     if(Trigger.isbefore){
        if(Trigger.isUpdate){
            OpportunityTriggerHandler.updateAmount(Trigger.new,trigger.oldMap);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            OpportunityTriggerHandler.afterUpdateOpportunity(Trigger.new);
        }
    }
     if(Trigger.isAfter){
        if(Trigger.isDelete){
            OpportunityTriggerHandler.deleteOppCreateTask(Trigger.Old);
        }
    }
    
}