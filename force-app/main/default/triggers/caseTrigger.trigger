trigger caseTrigger on Case (before insert,before update,before delete) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){  for(case cs:trigger.NEW){
            if(cs.Origin=='Email'){
                cs.Priority='high';
            }else if(cs.Origin=='Phone'){ 
                cs.Priority='Medium';}
            else{
                cs.Priority='low';
            }
        }
                            }
        if(Trigger.isUpdate){
            for(case cs:trigger.NEW){
                if(cs.Origin=='Email'){
                    cs.Priority='high';
                }else if(cs.Origin=='Phone'){ 
                    cs.Priority='Medium';}
                else{
                    cs.Priority='low';
                }
            }          
        }      
    }
    
    if(Trigger.isBefore && Trigger.isDelete){
        caseTriggerHandler.sysadmindeletecash(Trigger.Old);
        
    }
}