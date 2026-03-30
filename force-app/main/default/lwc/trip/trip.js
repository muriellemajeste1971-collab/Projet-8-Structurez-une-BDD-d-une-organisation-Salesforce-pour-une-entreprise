import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createTrip from '@salesforce/apex/OpportunityService.createTrips';

import { refreshApex } from '@salesforce/apex';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';

const FIELDS = ['Opportunity.StageName'];

export default class Trip extends LightningElement {

    @api recordId;
    previousStage;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ data }) {
        if (data) {
            const currentStage = data.fields.StageName.value;

            if (this.previousStage && currentStage === 'Closed Won' && this.previousStage !== 'Closed Won') {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Succès',
                        message: 'Séjour créé avec succès !',
                        variant: 'success'
                    })
                );
            }

            this.previousStage = currentStage;
        }
    }
}