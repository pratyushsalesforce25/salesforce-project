import { LightningElement, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class ApplicationForm extends LightningElement {

    
    @track currentStep = 0;

    @track steps = [
        { id: 1, title: 'Household', subtitle: 'Parent/guardian contact and address details', activeClass: 'active' },
        { id: 2, title: 'Children', subtitle: 'Multiple child entries with school and grade', activeClass: '' },
        { id: 3, title: 'Pickup', subtitle: 'Emergency contacts and pickup authorization', activeClass: '' },
        { id: 4, title: 'Household Details', subtitle: 'Church, household, income, and eligibilit', activeClass: '' },
        { id: 5, title: 'Medical', subtitle: 'Allergies, conditions, medications, physician', activeClass: '' },
        { id: 6, title: 'Consents', subtitle: 'Acknowledgments, signatures, review', activeClass: '' }
    ];

    totalSteps = 6;

    @track formData = {};
    @track children = [];
    @track completedSteps = [];


    get isStepOne() { return this.currentStep === 0; }
    get isStepTwo() { return this.currentStep === 1; }
    get isStepThree() { return this.currentStep === 2; }
    get isStepFour() { return this.currentStep === 3; }
    get isStepFive() { return this.currentStep === 4; }
    get isStepSix() { return this.currentStep === 5; }

    get currentStepNumber() {
        return this.currentStep + 1;
    }

    get currentStepTitle() {
        return this.steps[this.currentStep].title;
    }

    get currentStepDescription() {
        return this.steps[this.currentStep].subtitle;
    }

    get progressStyle() {
        let percent = ((this.currentStep + 1) / this.totalSteps) * 100;
        return `width:${percent}%`;
    }
    get isLastStep() {
    return this.currentStep === this.totalSteps - 1;
    }
   handleNext() {
    if (!this.completedSteps.includes(this.currentStep)) {
        this.completedSteps.push(this.currentStep);
    }

    if (this.currentStep < this.totalSteps - 1) {
        this.currentStep++;
        this.syncSteps();
    }
}
    handlePrevious() {
        if (this.currentStep > 0) {
            this.currentStep--;
            this.updateStepUI();
        }
    }
    handleStepClick(event) {
        const index = parseInt(event.currentTarget.dataset.index, 10);

         this.currentStep = index;
        this.syncSteps();
    }
updateStepUI() {
    this.steps = this.steps.map((step, i) => {

        let cls = '';

        if (i === this.currentStep) {
            cls = 'active'; 
        } else if (this.completedSteps.includes(i)) {
            cls = 'done'; 
        }

        return { ...step, activeClass: cls };
    });
}

    handleInputChange(event) {
        const field = event.target.dataset.field;
        this.formData[field] = event.target.value;
    }

    handleAddChild() {
        const newChild = {
            id: Date.now(),
            name: '',
            date: '',
            gender: '',
            school: '',
            grade: '',
            ethnicity: '',
            special:'',
            medications:''
        };

        this.children = [...this.children, newChild];
    }

    handleRemoveChild(event) {
        const index = event.currentTarget.dataset.index;
        this.children.splice(index, 1);
        this.children = [...this.children];
    }

    handleChildChange(event) {
        const index = event.target.dataset.index;
        const field = event.target.dataset.field;

        this.children[index][field] = event.target.value;
        this.children = [...this.children];
    }

    connectedCallback() {
        this.updateStepUI();
    }
handleSave() {
    
    alert('Form Submitted Successfully!');
    this.dispatchEvent(new CloseActionScreenEvent());
}
}