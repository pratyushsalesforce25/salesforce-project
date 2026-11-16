trigger AccountTrigger on Account (after Insert,before Update,after Update) {
    
     if(Trigger.IsAfter && Trigger.isInsert){
        AccountTriggerHandler.createnumberofcontact(Trigger.New);
    }
    if(Trigger.Isbefore && Trigger.isUpdate){
        AccountTriggerHandler.notchnagedownership(Trigger.New,Trigger.oldMap);     
    }
    if(Trigger.IsAfter && Trigger.isUpdate){
        AccountTriggerHandler.contactwebsiteupdate(Trigger.New,Trigger.oldMap);
         AccountTriggerHandler.createnumberofcontact(Trigger.New);
    }
}