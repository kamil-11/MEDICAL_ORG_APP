import { LightningElement, wire } from 'lwc';
import getWiredPhysician from '@salesforce/apex/GetPhysicianCTRL.getPhysician'
export default class GetPhysicianCMP extends LightningElement {
    searchKey ='';
    @wire(getWiredPhysician,{searchKey:'$searchKey'})
    Physician;

    handleKeyChange(event)
    {
        window.clearTimeout(this.delayTimeout)

        const searchKey = event.target.value;

        this.delayTimeout =setTimeout(()=>{
            this.searchKey = searchKey;
        },500)
    }

}