import { LightningElement, api, track } from 'lwc';
import adoptPet from '@salesforce/apex/PetController.adoptPet';
import adoptPetWithContact from '@salesforce/apex/PetController.adoptPetWithContact';
import searchContacts from '@salesforce/apex/PetController.searchContacts';

export default class PetAdoptionFormCmp extends LightningElement {
    @api petId;
    @track firstName = '';
    @track lastName = '';
    @track phone = '';
    @track email = '';
    @track street = '';
    @track postalCode = '';
    @track city = '';
    @track searchTerm = '';
    @track contacts = [];
    @track selectedContact = null;

    handleInputChange(event) {
        this[event.target.dataset.field] = event.target.value;
    }

    handleSearchInput(event) {
        this.searchTerm = event.target.value;
    }

    handleSearch() {
        if (this.searchTerm) {
            searchContacts({ searchTerm: this.searchTerm })
                .then(result => {
                    this.contacts = result;
                })
                .catch(error => {
                    // handle error
                });
        }
    }

    handleSelectContact(event) {
        const contactId = event.target.dataset.id;
        this.selectedContact = this.contacts.find(c => c.Id === contactId);
    }

    handleAdoptNew() {
        adoptPet({
            petId: this.petId,
            firstName: this.firstName,
            lastName: this.lastName,
            phone: this.phone,
            email: this.email,
            street: this.street,
            postalCode: this.postalCode,
            city: this.city
        })
            .then(() => {
                this.dispatchEvent(new CustomEvent('close'));
                this.dispatchEvent(new CustomEvent('refresh'));
            })
            .catch(error => {
                // handle error
            });
    }

    handleAdoptExisting() {
        if (this.selectedContact) {
            adoptPetWithContact({
                petId: this.petId,
                contactId: this.selectedContact.Id
            })
                .then(() => {
                    this.dispatchEvent(new CustomEvent('close'));
                    this.dispatchEvent(new CustomEvent('refresh'));
                })
                .catch(error => {
                    // handle error
                });
        }
    }

    handleClose() {
        this.dispatchEvent(new CustomEvent('close'));
    }
} 