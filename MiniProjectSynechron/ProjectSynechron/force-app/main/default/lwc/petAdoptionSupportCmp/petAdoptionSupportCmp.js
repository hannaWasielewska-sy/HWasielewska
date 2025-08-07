import { LightningElement, track } from 'lwc';
import getPets from '@salesforce/apex/PetController.getPets';

export default class PetAdoptionSupportCmp extends LightningElement {
    @track pets;
    @track showAdoptionForm = false;
    @track selectedPetId;
    @track filter = 'All';

    connectedCallback() {
        this.loadPets(this.filter);
    }

    loadPets(filter) {
        this.filter = filter;
        getPets({ filter })
            .then(result => {
                this.pets = result;
            })
            .catch(error => {
                // handle error
            });
    }

    handleAll() {
        this.loadPets('All');
    }
    handleAdopted() {
        this.loadPets('Adopted');
    }
    handleForAdoption() {
        this.loadPets('ForAdoption');
    }

    handleAdopt(event) {
        this.selectedPetId = event.detail.petId;
        this.showAdoptionForm = true;
    }

    handleFormClose() {
        this.showAdoptionForm = false;
        this.selectedPetId = null;
    }

    handleFormRefresh() {
        this.showAdoptionForm = false;
        this.selectedPetId = null;
        this.loadPets(this.filter);
    }
} 