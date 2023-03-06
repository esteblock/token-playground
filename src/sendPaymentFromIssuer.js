import StellarSdk from "stellar-sdk";

const sendPaymentFromIssuer = async function (
                                        server,
                                        networkPassphrase, 
                                        issuer, 
                                        issuingKeys, 
                                        asset, 
                                        destination,
                                        amount) {
    console.log("sendPaymentFromIssuer: Building the transaction")
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
  }

export {sendPaymentFromIssuer}