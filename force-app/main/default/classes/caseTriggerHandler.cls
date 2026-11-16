public class caseTriggerHandler {

    Public static void sysadmindeletecash(list<case> cashlist){
        Id currentuserprofile=Userinfo.getprofileId();
        Id sysAdminProfile = [SELECT Id,name FROM profile where name ='System Administrator' Limit 1].id;
        for(case ca :cashlist){
            if(currentuserprofile != sysAdminProfile){
                ca.addError('Only System Admin Profile Users can delete this Case Object Record.');
            }
        }
    }
}