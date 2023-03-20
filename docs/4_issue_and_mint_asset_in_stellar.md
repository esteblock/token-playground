# Token Playground Chapter 4 :  Issue and Mint Asset in Stellar.

Token playgroud includes a node script that issue a stellar asset. You can run it by:


```
  docker exec soroban-preview-7 node src/issueAsset.js
```

Also you can  run  establishing a different asset code from settings.json

```
  docker exec soroban-preview-7 node src/issueAsset.js ASSET_CODE
```


This script will send two transaction to stellar futurenet or standalones, depende you selection on launching quicktart.sh 


### 1.- Trust Operation 

Previous to the creation of the asset, the destination address is required to send a transaction to the network that creates a trustline with the asset. Any address cannot receive an asset which previously if it has not a trustline created. 

The transaction that will creates the trustline need to contain an operation "Change Trust" where the fields  `asset` (asset code and issuer addres) is required and the field  `trust limit` is optional.  

```
const trustAssetResult = await trustAsset(server, 
                                            settings.networkPassphrase,
                                            receiver,
                                            receivingKeys, 
                                            asset,
                                            settings.limit)

```
you can check how building trust operation  [here](https://github.com/esteblock/token-playground/blob/main/src/trustAsset.js)


### 2.-  Issue Asset 


Once the destination address trust the asset,  Issuer can create asset. Issue the asset consist in building a transaction that contains a payment operation. Payment operation requires set up asset code, issuer adress and amount. This payment will create the token and  mint the amount user send to destination address. 



```
 const sendPaymentResult = await sendPaymentFromIssuer(server,
                                                          settings.networkPassphrase,
                                                          issuer,
                                                          issuingKeys,
                                                          asset,
                                                          receivingKeys.publicKey(),
                                                          settings.amount)
```

you can check how building payment  operation  [here](https://github.com/esteblock/token-playground/blob/main/src/trustAsset.js)


In case issuer addres is not locked, new amount of the asset can be minted. To mint the asset is  as easy as create  anew payment operation. The amount of the operation will mint the asset incrementing total supply of the asset. 

