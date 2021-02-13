import { LightningElement,track } from 'lwc';
import getOrdersByAccount from '@salesforce/apex/LWCTroudOrdersByAccountController.getOrdersByAccount';

export default class LwcTestOrder extends LightningElement {


    connectedCallback(){
        this.getOrdersByAccountFromApex();
    }


}