import StellarSdk from "stellar-sdk";
const horizonUrl = "https://horizon-testnet.stellar.org";
const assetCode= "ABBA"
console.log("Using asset_code: ", assetCode)
var server = new StellarSdk.Horizon.Server(horizonUrl, {allowHttp: true});
console.log("Futurenet Classic Info: ")
console.log((await server.assets().forCode(assetCode).call()).records[0])


const issuer="GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5";
console.log((await server.assets().forIssuer(issuer).call()))
