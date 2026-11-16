public with sharing class ApplicationService {
    
    @AuraEnabled
    public static ResponseWrapper saveApplication(FormWrapper formData) {
        
        ResponseWrapper res = new ResponseWrapper();
        
        try {
            Account acc = new Account();
            
            if(formData.household != null){
                acc.Name = formData.household.name;
                acc.Phone = formData.household.phone;
                acc.BillingStreet = formData.household.address;
            }
          
            acc.Active__c = true;
            
            insert acc;
            
            Contact primaryCon = new Contact(
                FirstName = formData.primaryParent.firstName,
                LastName = formData.primaryParent.lastName,
                Email = formData.primaryParent.email,
                Phone = formData.primaryParent.phone,
                AccountId = acc.Id,
                Roles__c= formData.primaryParent.role,
                Is_Primary__c = true,
                Can_Pay__c = true,
                Can_Receive_Notifications__c = true,
                Can_Sign_Form__c = true
            );
            insert primaryCon;
            
            
            acc.Primary_Parent__c= primaryCon.Id;
            update acc;
            
            
            List<Student__c> studentList = new List<Student__c>();
            
            for (StudentWrapper sw : formData.students) {
                
                Student__c stu = new Student__c(
                    First_Name__c = sw.firstName,
                    Last_Name__c = sw.lastName,
                    Date_of_Birth__c = sw.dob,
                    Grade__c = sw.grade,
                    School__c = sw.school,
                    Allergies__c = sw.allergies,
                    Medical_Notes__c = sw.medicalNotes,
                    Household__c = acc.Id,
                    Emergency_Contact__c = primaryCon.Id,
                    Active__c = true
                );
                
                studentList.add(stu);
            }
            
            insert studentList;
            
            List<Program_Application__c> appList = new List<Program_Application__c>();
            
            for (Student__c stu : studentList) {
                
                Program_Application__c app = new Program_Application__c(
                    Student__c = stu.Id,
                    Household__c = acc.Id,
                    Parent__c = primaryCon.Id,
                    Program__c = formData.application.programId,
                    Session__c = formData.application.sessionId,
                    Campus__c = formData.application.campus,
                    Status__c = 'Draft',
                    Application_Date__c = Date.today(),
                    Submitted_from_Website__c = true
                );
                
                appList.add(app);
            }
            
            insert appList;
            
            
            res.success = true;
            res.message = 'Application Created Successfully';
            res.applicationIds = new List<String>();
            
            for (Program_Application__c app : appList) {
                res.applicationIds.add(app.Name);
            }
            
        } catch (Exception e) {
            res.success = false;
            res.message = e.getMessage();
        }
        
        return res;
    }
    
    
    public class FormWrapper {
        @AuraEnabled public HouseholdWrapper household;
        @AuraEnabled public ParentWrapper primaryParent;
        @AuraEnabled public List<StudentWrapper> students;
        @AuraEnabled public ApplicationWrapper application;
    }
    
    public class HouseholdWrapper {
        @AuraEnabled public String name;
        @AuraEnabled public String phone;
        @AuraEnabled public String address;
    }
    
    public class ParentWrapper {
        @AuraEnabled public String firstName;
        @AuraEnabled public String lastName;
        @AuraEnabled public String email;
        @AuraEnabled public String phone;
        @AuraEnabled public String role;
    }
    
    public class StudentWrapper {
        @AuraEnabled public String firstName;
        @AuraEnabled public String lastName;
        @AuraEnabled public Date dob;
        @AuraEnabled public String grade;
        @AuraEnabled public String school;
        @AuraEnabled public String allergies;
        @AuraEnabled public String medicalNotes;
    }
    
    public class ApplicationWrapper {
        @AuraEnabled public Id programId;
        @AuraEnabled public Id sessionId;
        @AuraEnabled public String campus;
    }
    
    public class ResponseWrapper {
        @AuraEnabled public Boolean success;
        @AuraEnabled public String message;
        @AuraEnabled public List<String> applicationIds;
    }
}