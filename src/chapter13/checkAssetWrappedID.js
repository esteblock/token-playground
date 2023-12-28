import * as StellarSdk from "stellar-sdk";
import settings from "/workspace/settings.json"  assert { type: "json" };


const args = process.argv;
const asset_code = args[2];
const asset_issuer = args[3];
console.log("Using asset_code: ", asset_code)
console.log("Using asset_issuer: ", asset_issuer)
var networkPassphrase = settings.networkPassphrase
console.log("Using networkPassphrase: ", networkPassphrase)

try{

  var asset = new StellarSdk.Asset(asset_code, asset_issuer );
  console.log("Asset should have the following Contract ID: ", asset.contractId(networkPassphrase))
  //console.log("Asset has a correct format: ", asset)
}
catch(error){
  console.error("Error! while creating the asset object: ", error)
} 