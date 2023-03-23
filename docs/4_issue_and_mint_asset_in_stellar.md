# Token Playground Chapter 4 :  Issue and Mint Asset in Stellar.

- Check this guide in [https://token-playground.gitbook.io/](https://token-playground.gitbook.io/)
- Edit this guide in it's repo: [https://github.com/esteblock/token-playground/](https://github.com/esteblock/token-playground/)
- Contribute to this guide in the [./docs folder](https://github.com/esteblock/token-playground/tree/main/docs) of the repo

# Introduction:

In this chapter we will  show you how to issue (create) a Stellar Asset (classic) and mint the the first supply of it. 

To issue and mint an asset you need to build and submit two transactions. The first one will to create a **trustline** for the asset between receiver and issuer address, this is a requirement. The second one **will send a payment** of the asset  from issuer to receiver that effectivaly **will create and mint the asset by sending it+*.   

Remember to **follow the code** in the [Token Playground's Repo](https://github.com/esteblock/token-playground/). Also, you can clone the code by doing

```bash
git clone https://github.com/esteblock/token-playground/
```


# 1.- Trust Operation 

Previous to the creation of the asset, the destination address is required to submit a transaction to the network that creates a trustline with the asset.  In Stellar, this is a requirement to establish a trustline before receiving an asset that has not been received before.

Read more about trustlines in the [Stellar's Trustlines section](https://developers.stellar.org/docs/fundamentals-and-concepts/stellar-data-structures/accounts#trustlines)

The transaction that will creates the trustline need to contains an operation `Change Trust` where the fields  `asset` (asset code and issuer address) is required and the field  `trust limit` is optional.  

You can check the full code of this playground, on how to build build and submit this trust operation [in our `trustAsset.js` script](https://github.com/esteblock/token-playground/blob/main/src/trustAsset.js)

Here we show you a fragment of this code, using the javascript `StellarSdk` package:

```javascript

  var transaction = new StellarSdk.TransactionBuilder(receiver, {
        fee: 100,
        networkPassphrase: networkPassphrase,
    })
        // The `changeTrust` operation creates (or alters) a trustline
        // The `limit` parameter below is optional
        .addOperation(
        StellarSdk.Operation.changeTrust({
            asset: asset,
            limit: limit,
        }),
        )
        // setTimeout is required for a transaction
        .setTimeout(100)
        .build();
    console.log("trustAsset: Transaction built")
    transaction.sign(receivingKeys);
    console.log("trustAsset: Transaction signed, now will submit transaction")
    var submitResult = server.submitTransaction(transaction);
    console.log("trustAsset: Tx is being submitted, result: ", submitResult)
    return submitResult
```

# 2.  Issue Asset 


Once the destination address trust the asset,  the issuer can create it. Issuing the asset consist in building  and submit a transaction that contains a payment operation. The payment operation requires to set up the `asset code`,the `issuer adress` and the `amount`. This payment will create the token and  mint the amount that the issuer sends to destination address. 


You can check the full code of this playground, on how to build build and submit the transaction with a payment  operation [in our `sendPaymentFromIssuer.js` script](https://github.com/esteblock/token-playground/blob/main/src/sendPaymentFromIssuer.js)

Here we show you a fragment of this code, using the javascript `StellarSdk` package:

Here a fragment of this code:

```javascript
var transaction = new StellarSdk.TransactionBuilder(issuer, {
    fee: 100,
    networkPassphrase: networkPassphrase,
  })
    .addOperation(
      StellarSdk.Operation.payment({
        destination: destination,
        asset: asset,
        amount: amount,
      }),
    )
    // setTimeout is required for a transaction
    .setTimeout(100)
    .build();
  console.log("sendPaymentFromIssuer: Signing the transaction")
  transaction.sign(issuingKeys);
  var submitResult = server.submitTransaction(transaction);
  console.log("sendPaymentFromIssuer: Tx is being submitted, result: ", submitResult)
  return submitResult

```

In the case the issuer addres is not locked, new amount of the asset can be minted. To mint the asset is as easy as create a new transanction with a payment operation. This operation will mint the asset incrementing the total supply of the asset.

# 3. Use our code

If you want to use our [Token Playground's Repo](https://github.com/esteblock/token-playground/) **code**, we prepared the [src/issueAsset.js](https://github.com/esteblock/token-playground/blob/main/src/issueAsset.js) script that can be called by the `soroban-preview-7` docker container:

You can run it by:

```bash
  docker exec soroban-preview-7 node src/issueAsset.js
```

Also you can run it with a different asset code than the one in settings.json by passing it the `ASSET_CODE` argument. 

```bash
  docker exec soroban-preview-7 node src/issueAsset.js ASSET_CODE
```

This script will send two transactions to the stellar futurenet or standalone chains, depend on your selection when launching [quicktart.sh](https://github.com/esteblock/token-playground/blob/main/quickstart.sh). 


This script will take the asset, issuer adress, receiver address, amount, network passphrase and limit amount allowed to be received by receiver address from the [seetings.json](https://github.com/esteblock/token-playground/blob/main/settings.json) file. 

```javascript
import settings from "../settings.json"  assert { type: "json" };

const args = process.argv;
const asset_code = args[2] || settings.assetCode;

...

var networkPassphrase = settings.networkPassphrase
var issuingKeys = StellarSdk.Keypair.fromSecret(settings.issuerSecret);
var receivingKeys = StellarSdk.Keypair.fromSecret(settings.receiverSecret);

...

```
As we have showed above you can pass the asset code as an argument when invoking the script. 

# 4. Next

In the [next chapter](5_get_info_about_token_in_stellar.md) we will use this docker containers in order to get info about the asset created in the current chapter

___

This Playground has been developed by [@esteblock](https://github.com/esteblock/) in collaboration with [@marcos74](https://github.com/marcos74) from [@Dogstarcoin](https://github.com/Dogstarcoin)

