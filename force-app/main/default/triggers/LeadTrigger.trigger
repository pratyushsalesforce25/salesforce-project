trigger LeadTrigger on Lead (before update,After Insert,before delete) {
    if(Trigger.isBefore && Trigger.isUpdate){
        for(lead le:Trigger.NEW){
            if(le.LeadSource == 'web'){
                le.Rating='Hot';
            }
        }
    }
    if(Trigger.isAfter && Trigger.isInsert){
        LeadTriggerhandler.InsertTask(Trigger.NEW);
    }
    if(trigger.isbefore && Trigger.isDelete){
        LeadTriggerhandler.notdeletestatusWorking(trigger.Old);
    }
}