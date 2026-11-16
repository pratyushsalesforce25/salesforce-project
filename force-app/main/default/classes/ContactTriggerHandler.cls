public class ContactTriggerHandler {

    public static void parentAccountNotNull(list<contact>contactlist){
        for(Contact con:contactlist){
            if(con.AccountId == null){
                con.addError('Plese Fill  Household Name ');
            }
        }
    }
    
    public static void checkduplicate(List<contact>conlist){
        list<contact>existingcontact=[select id,LastName,email,MobilePhone from contact Limit 5000];
        for(contact con:conlist){
            for(contact extcontact:existingcontact){
                if(con.MobilePhone == extcontact.MobilePhone && con.Email == extcontact.Email && con.LastName == extcontact.LastName){
                    con.adderror('Duplicate Found contact LastName = ' + con.LastName + ' & contact Phone = ' + con.MobilePhone + ' & contact Email = ' + con.email + ' ');
                }
            }    
        }       
    }
    public static void shareContactActivity(list<contact> conlist){
        list<ContactShare> addRecordToList = new list<ContactShare>();
      Id coninnvoPublicGroup=[Select id From Group Where name='Contact Information' limit 1].id; 

        For(contact Con:conlist){
            ContactShare Cons = new ContactShare();
            Cons.ContactAccessLevel='Edit';
            Cons.ContactId=Con.Id;
            Cons.RowCause ='Manual';
            Cons.UserOrGroupId=coninnvoPublicGroup;
            addRecordToList.add(Cons);
        }      
        If(!addRecordToList.isEmpty()){
            insert addRecordToList;
        }
    }
}