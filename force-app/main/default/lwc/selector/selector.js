import { LightningElement, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';

const fields = [NAME_FIELD];

export default class Selector extends LightningElement {
    selectedProductId = null;

    userId = Id;

    @wire(getRecord, { recordId: '$userId', fields })
    user;

    get name() {
        return this.user && this.user.data
            ? getFieldValue(this.user.data, NAME_FIELD)
            : '';
    }

    handleProductSelected(evt) {
        this.selectedProductId = evt.detail;
    }
}