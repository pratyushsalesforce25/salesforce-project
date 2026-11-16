import { LightningElement, track } from 'lwc';
import createAccountContact from '@salesforce/apex/AccountContactController.createAccountContact';

export default class AccountContactForm extends LightningElement {

    accountName;
    accountPhone;
    firstName;
    lastName;
    mobile;

    @track showThankYou = false;
    @track createdAccountName;
    @track errorMessage;
    @track isLoading = false;

    handleAccountName(event){
        this.accountName = event.target.value;
    }

    handleAccountPhone(event){
        this.accountPhone = event.target.value;
    }

    handleFirstName(event){
        this.firstName = event.target.value;
    }

    handleLastName(event){
        this.lastName = event.target.value;
    }

    handleMobile(event){
        this.mobile = event.target.value;
    }

    handleSave(){

        this.isLoading = true;
        this.errorMessage = null;
        
        createAccountContact({
            accName: this.accountName,
            accPhone: this.accountPhone,
            firstName: this.firstName,
            lastName: this.lastName,
            mobile: this.mobile
        })
        .then(result => {
            this.createdAccountName = result;
            this.showThankYou = true;
            this.isLoading = false;
        })
        .catch(error => {
            console.error('Full error:', error);
            this.isLoading = false;
  
            if (error.body && error.body.message) {
                this.errorMessage = error.body.message;
            } else if (error.message) {
                this.errorMessage = error.message;
            } else {
                this.errorMessage = 'An unknown error occurred. Please try again.';
            }
        });
    }
}