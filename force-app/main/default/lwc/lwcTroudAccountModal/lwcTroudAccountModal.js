import { LightningElement,api } from 'lwc';
import getOrdersByAccount from '@salesforce/apex/LWCTroudOrdersByAccountController.getOrdersByAccount';

export default class LwcTroudAccountModal extends LightningElement {
    @api accountId;
    @api routeSheetId;
    orderList = [];
    
    connectedCallback(){
        console.log('accountId: ' + this.accountId);
        console.log('routeSheetId: ' + this.routeSheetId);
    }

    disconnectedCallback(){
        console.log('lwcTroudOrdersByAccount disconnected');
    }

    closeModal(event){
        const customEvent = new CustomEvent(
            'closeordermodal', {
                detail: false
            }
        );
        this.dispatchEvent(customEvent);
    }
}