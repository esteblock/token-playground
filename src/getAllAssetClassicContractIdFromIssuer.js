import fetch from 'node-fetch'
import StellarSdk from "stellar-sdk";
import * as SorobanClient from "soroban-client" // // import * as SorobanClient from "stellar-sdk"
import settings from "../settings.json"  assert { type: "json" };
const xdr  = StellarSdk.xdr;

const contractIds = []
console.log("Getting all contract id from issuer account (limit to first 200 operations)");
await fetch(settings.horizonUrl +  "/accounts/" + settings.issuerPublic +"/operations?limit=200" )
.then(response =>  response.json())
.then(  (data) => {

    data._embedded.records.forEach(  record =>  {
       
        if ( record.type == "ContractIdTypeContractIdFromAsset" ) { 
            const footprint = SorobanClient.xdr.LedgerFootprint.fromXDR( record.footprint, 'base64')
            const contractId = footprint._attributes.readWrite[0]._value._attributes.contractId.toString('hex')
            contractIds.push({
                transaction_hash : record.transaction_hash,
                contract_id : contractId
            })
        }

        
    });

});
contractIds.forEach( async record =>  {

    await  fetch(settings.horizonUrl +  "/transactions/" + record.transaction_hash)
        .then(response =>  response.json())
        .then( (data) => {
            
            try{
                const transaction_envelope = SorobanClient.xdr.TransactionEnvelope.fromXDR(data.envelope_xdr ,'base64');
                const asset_code =  transaction_envelope.value()._attributes.tx._attributes.operations[0]._attributes.body._value._attributes.function._value._attributes.contractId._value._value._attributes.assetCode.toString('hex')
                let asset_code_str= "";
                for (var n = 0; n < asset_code.length; n += 2) {
                    asset_code_str += String.fromCharCode(parseInt(asset_code.substr(n, 2), 16));
                }   
                console.log("ContractId: " + record.contract_id)
                console.log("ASSET: " +asset_code_str +":" + settings.issuerPublic)
            } catch (error) {
                console.error(error);
            }   
          
     });

 });