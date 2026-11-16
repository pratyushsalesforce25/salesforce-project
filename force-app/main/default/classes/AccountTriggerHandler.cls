public class AccountTriggerHandler {
    public Static void notchnagedownership(list<Account> acclist, map<id ,Account> accOldMap){
        for(Account acc:acclist){
            if(acc.Industry == 'Agriculture' && acc.Type =='Prospect'){
                if(accOldMap.get(acc.Id).Ownership != acc.Ownership) {
                    acc.addError('Can Not Edit This Ownership Record');
                }
            }
        }
    }
    
    public Static void contactwebsiteupdate(list<account>acclist,map<id,account> accOldMap){
        map<id,string> accmap = new map<id,string>();
        
        for(account acc:acclist){
            Account accoldvalue=accoldmap.get(acc.Id);
            if(accoldvalue.Website !=acc.Website){
                accmap.put(acc.id,acc.Website);
                
            }
        }
        if(accmap.keyset().size() > 0){
            
            list<contact>contactlist=[select id,website__c,accountid from contact where accountid IN :accmap.keyset()];
            
            for(contact con:contactlist){
                con.Website__c=accmap.get(con.AccountId);   
                
            }
            if(!contactlist.isEmpty()){
                update contactlist;
            }
        }
    }
    
    public static void createnumberofcontact(list<account> acclist){
        list<contact> conlist =new list<contact>();
        
        for(account acc:acclist){
            if(acc.Account_N_Contact__c != null){
                for(integer i = 0; i < acc.Account_N_Contact__c; i++){
                    contact con =new contact();
                    con.FirstName='Acc';
                    con.LastName=acc.Name + i;
                    con.AccountId=acc.Id;
                    con.Description=acc.Description;
                    con.MailingCity=acc.BillingCity;
                    con.MailingStreet=acc.BillingStreet;
                    con.MailingState=acc.BillingState;
                    con.MailingCountry=acc.BillingCountry;
                    con.MailingPostalCode=acc.BillingPostalCode;                    
                    conlist.add(con);
                }
            }
            
            if(!conlist.isempty()){
                insert conlist;
                system.debug('Account record' + conlist);
            }
        }
    }
}