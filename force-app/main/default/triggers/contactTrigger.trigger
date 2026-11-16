trigger contactTrigger on Contact (before insert,after insert) {
    if(Trigger.isBefore && Trigger.isInsert){
        ContactTriggerHandler.parentAccountNotNull(Trigger.New);
        ContactTriggerHandler.checkduplicate(Trigger.New);
    }
    if(Trigger.isAfter && Trigger.isInsert) {
          ContactTriggerHandler.shareContactActivity(Trigger.New);       
    }
}