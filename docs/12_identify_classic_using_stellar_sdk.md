# Token Playground Chapter 12 : Identify a Stellar Classic Asset using stellar-sdk
How can we know if a specific asset is a Stellar Classic Asset?

Create an asset:
```
bash quickstart.sh standalone
bash run.sh
node src/friendbot.js
node src/issueAsset.js AAA
```
This will return:
```
ASSET ISSUED:  Asset {
  code: 'ABCD',
  issuer: 'GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI'
}
```
## From a SYMBOL:ISSUER address

1.- See if the combination have a correct format:
```javascript
var asset = new StellarSdk.Asset(asset_code, asset_issuer );
```
This will create an asset object. If either the asset_code or the asset_issuer are not in a good format, this will fail.

Test with:
```
node src/chapter12/checkFormat.js ABC GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI
```

## See if the asset exist?
Can we know if for an asset we have totalSupply or something?

Can we use this in stellar-sdk?
```
https://horizon-testnet.stellar.org/assets?asset_code=ASSET_CODE&asset_issuer=ISSUER_ADDRESS
```

## From a wrapped asset contract address