import { LightningElement, api } from 'lwc';
import getOrdersByAccount from '@salesforce/apex/LWCTroudOrdersByAccountController.getOrdersByAccount';

export default class LwcTroudOrdersByAccount extends LightningElement {

    gridColumns = [
        {
            type: 'url',
            fieldName: 'url',
            label: 'Order',
            typeAttributes: {
                label: { fieldName: 'name' },
            },
            initialWidth: 300,
            cellAttributes: { alignment: 'left' }
        },
        {
            type: 'number',
            fieldName: 'totalAmount',
            label: 'Total Amount',
            initialWidth: 200,
            cellAttributes: { alignment: 'left' }  
        },
        {
            type: 'date',
            fieldName: 'orderDate',
            label: 'Order/Order Product Created Date',
            initialWidth: 160,
            cellAttributes: { alignment: 'left' }
        },
        {
            type: 'number',
            fieldName: 'productQuantity',
            label: 'Total per Product',
            initialWidth: 160,
            cellAttributes: { alignment: 'left' }
        }
    ];
    
    gridData = [];

    @api accountId;
    @api routeSheetId;

    connectedCallback(){
        console.log('account on child:  ' + this.accountId);
        this.getOrdersByAccountFromApex();
    }
    
    getOrdersByAccountFromApex(){
        getOrdersByAccount({
            accountId: this.accountId,
            routeSheetId: this.routeSheetId
        })
        .then(result => {
            var formatResult = result;
            this.gridData = formatResult.map(row=>{
                return{...row,
                    _children: row.children}
            });
            console.log('this.gridData: ' , this.gridData);
        })
        .catch(error => {
            console.log('error lwcGetOrderByAccount: ' , error);
        });
    }
}