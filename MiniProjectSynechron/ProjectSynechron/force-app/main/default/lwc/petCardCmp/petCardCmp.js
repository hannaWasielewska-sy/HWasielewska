import { LightningElement, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

export default class PetCardCmp extends LightningElement {
    @api pet;

    get petUrl() {
        return `/lightning/r/Pet__c/${this.pet.Id}/view`;
    }

    get OwnerName() {
        // If pet.Owner is a related Contact, try to get the name
        return this.pet.Owner__r ? this.pet.Owner__r.Name : '';
    }

    get showAdoptButton() {
        // Show Adopt button only if For_Adoption__c is true and Owner__c is not set
        return this.pet.For_Adoption__c && !this.pet.Owner__c;
    }

    handleAdopt() {
        this.dispatchEvent(new CustomEvent('adopt', { detail: { petId: this.pet.Id } }));
    }
} 