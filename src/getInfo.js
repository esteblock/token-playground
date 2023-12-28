import StellarSdk from "stellar-sdk";
import settings from "../settings.json"  assert { type: "json" };


const args = process.argv;
const asset_code = args[2] || settings.assetCode;
console.log("Using asset_code: ", asset_code)

var server = new StellarSdk.Horizon.Server(settings.horizonUrl, {allowHttp: true});

console.log("Futurenet Classic Info: ")
console.log((await server.assets().forCode(asset_code).call()).records[0])
