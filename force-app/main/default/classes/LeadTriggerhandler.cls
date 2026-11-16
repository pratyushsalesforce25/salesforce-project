public class LeadTriggerhandler {
    Public Static Void InsertTask(list<lead>leadRecord){
        
         list<Task> createTask = new list<Task>();
         For(Lead le:leadRecord){
            
             Task Ta=New Task();
             Ta.OwnerId=le.OwnerId;
             Ta.WhoId=le.Id;
             Ta.Priority='High';
             Ta.Description='This Task Is Created';
             Ta.Status='Not Started';
             Ta.Subject='Split Lead ';
            
              createTask.add(ta);         
        }
        if(!createTask.isEmpty()){
            Insert createtask;
        }
    }
    public static void notdeletestatusWorking(list<lead> oldleadlist){
        for(lead le : oldleadlist){
            if(le.Status == 'Working - Contacted'){
                le.status.adderror('lead status is Working - Contacted record You Can Not Delete');
            }
        }
        
    }
}