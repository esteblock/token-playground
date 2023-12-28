# Token Playground Chapter 13 : Wrap an asset using stellar-sdk
In a frontend we would like to help the user to wrap a Stellar Classic Asset in order to later, use it in a Soroban Smart Contract

## Calculate the contract ID

We can calculate the wrapped contract ID, even if the asset does not yet exist:

```
bash quickstart.sh standalone
bash run.sh
#node src/friendbot.js
node src/chapter13/checkAssetWrappedID.js ABC GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI
```

## See if the contract exist
We might call to a "balance" function and see if this fails?

##