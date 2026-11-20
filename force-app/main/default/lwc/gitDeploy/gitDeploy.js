import { LightningElement, api } from 'lwc';
export default class GitDeploy extends LightningElement {
@api brandName = 'Brand Name';

  handleNavClick(event){
    const selectedPage = event.target.dataset.page;
        console.log('Navigated to:', selectedPage);}
}
