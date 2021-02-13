import { LightningElement, api, track } from 'lwc';
import getTroudRouting from '@salesforce/apex/LWCTroudAppController.getTroudRouting';

export default class LwcTroudApp extends LightningElement {

    @api recordId;

    /* scary conditionals */
    isFirstRenderedCallback = true;
    /* map variables */
    mapMarkers = [];
    notOpenOrderOnConnectedCallback = true;
    /* orders by account variables */
    openOrder = false;
    accountId2RetriveOrders;

    connectedCallback(){
        console.log('routeSheetId: ' + this.recordId);
        this.getTroudRoutingFromApex();
    }
    renderedCallback(){

        /* This conditional logic was applied because handleMarkerSelect 
           is executed after the first render open automatically the order.
           To avoid that there's a conditional to be evaluate in the second
           renderedCallback of the component */
        if(!this.isFirstRenderedCallback){
            this.notOpenOrderOnConnectedCallback = false;
        } 
        if(this.isFirstRenderedCallback){
            this.isFirstRenderedCallback = false;
        }
        /* ------------------------------------------------------------- */
        
    }

    getTroudRoutingFromApex(){
        getTroudRouting({
            routeSheetId : this.recordId
        })
        .then(result => {
            this.mapMarkers = result;
            this.selectedMarkerValue = this.mapMarkers[0].value;
        })
        .catch(error => {
            console.log(error);
        })
    }

    closeOrderModal(event){
        //Custom event from lwcTroudOrdersByAccount
        console.log('close: ' + event.detail);
        this.openOrder = event.detail;
    }

    handleMarkerSelect(event) {
        if(!this.notOpenOrderOnConnectedCallback){
            this.openOrder = true;
            this.accountId2RetriveOrders = this.selectedMarkerValue = event.target.selectedMarkerValue;
        }
    }
}