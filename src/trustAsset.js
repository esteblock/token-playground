import StellarSdk from "stellar-sdk";

const trustAsset = async function (server,
                                    networkPassphrase, 
                                    receiver, 
                                    receivingKeys, 
                                    asset, 
                                    limit,
                                    ) {
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
  }

export {trustAsset}