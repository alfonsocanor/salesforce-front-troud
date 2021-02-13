import { LightningElement, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import ACCOUNT_LATITUDE from '@salesforce/schema/Account.ShippingLatitude';
import ACCOUNT_LONGITUDE from '@salesforce/schema/Account.ShippingLongitude';

export default class LightningExampleMapSingleMarker extends LightningElement {
    @api recordId;
    mapMarkers;

    @wire(getRecord, { recordId: '$recordId', fields: [ACCOUNT_LATITUDE,ACCOUNT_LONGITUDE] })
    wiredAccount({ error, data }) {
        if (data) {
            console.log('DATA: ' ,  data);
            this.mapMarkers = [
                {
                    location: {
                        Latitude: data.fields.ShippingLatitude.value,
                        Longitude: data.fields.ShippingLongitude.value
                    }
                },
            ]; 
        }
    }
}
