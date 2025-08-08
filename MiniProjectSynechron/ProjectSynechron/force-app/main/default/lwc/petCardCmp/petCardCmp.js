import { LightningElement, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

export default class PetCardCmp extends LightningElement {
    @api pet;

    get petUrl() {
        return `/lightning/r/Pet__c/${this.pet.Id}/view`;
    }

    get OwnerName() {
        return this.pet.Owner__r ? this.pet.Owner__r.Name : '';
    }

    get showAdoptButton() {
        return this.pet.For_Adoption__c && !this.pet.Owner__c;
    }

    handleAdopt() {
        this.dispatchEvent(new CustomEvent('adopt', { detail: { petId: this.pet.Id } }));
    }
} 