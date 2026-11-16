trigger TaskTrigger on Task (before insert) {

    if(Trigger.isBefore && Trigger.isinsert){
        for(Task taskre:Trigger.NEW){
            taskre.Priority='Low';
        }
    }
}