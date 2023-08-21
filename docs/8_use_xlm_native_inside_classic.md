# Token Playground Chapter 8 : Use the native Stellar Lumens (XLM) the classic way.


- Check this guide in [https://token-playground.gitbook.io/](https://token-playground.gitbook.io/)
- Edit this guide in it's repo: [https://github.com/esteblock/token-playground/](https://github.com/esteblock/token-playground/)
- Contribute to this guide in the [./docs folder](https://github.com/esteblock/token-playground/tree/main/docs) of the repo

## 1. Introduction
What about when we want to use XLM inside a Soroban smart contract? How do we trigger those transactions? Can we trigger transactions on behalf the user using the `require_auth` method?
 
In this chapter we will start using XLM, asking for our balance the classic way (without Soroban). In the next chapter we will use Soroban!

## 2. The native Stellar Lumens (XLM) contract address
Soroban is great! And in order to use the native XLM tokens, we just need to treat it as another asset that behaves as an Stellar Asset Contract (SAC). It indeed has it's own contract address.

This contract address is unique per network (standalone, futurenet... and later will be testnet and mainnet), so be sure to call it correctly.

In order to get the XLM "contract address" you just need to type:

```bash
soroban lab token id --asset native --network standalone
```
and you'll get 
```bash
CDMLFMKMMD7MWZP3FKUBZPVHTUEDLSX4BYGYKH4GCESXYHS3IHQ4EIG4
```

and for the case of futurenet you'll get:
```bash
soroban lab token id --asset native --network futurenet
CB64D3G7SM2RTH6JSGG34DDTFTQ5CFDKVDZJZSODMCX4NJ2HV2KN7OHT
```

## 3. Check your own balance using the classic way
Let's do our first experiment with the native XLM contract. We will create a new account, fund it with friendbot and check our balance in the classic way.

0.- Run the `quickstart.sh` script and enter into the soroban-preview container. Read chapter 1 and 2.
```bash
bash quickstart.sh
bash run.sh
```

1.- Create a new account:
```bash 
soroban config identity generate my-account
MY_ACCOUNT_ADDRESS="$(soroban config identity address my-account)"
```
2.- Fund it with friendbot. Here I'll assume you are inside the soroban-preview containter
```bash
SOROBAN_RPC_HOST="http://stellar:8000"
FRIENDBOT_URL="$SOROBAN_RPC_HOST/friendbot"
curl  -X POST "$FRIENDBOT_URL?addr=$MY_ACCOUNT_ADDRESS"
```

3.- Check your balance with the classic way
Using javascript and node, and assuming that MY_ACCOUNT_ADDRESS="GC6IYOXRAGMVSUDCAHBGBP2ZCAMZVNIF7CZCBY6545EQMIDNQQZCOY5G"

```javascript
var user_address="GC6IYOXRAGMVSUDCAHBGBP2ZCAMZVNIF7CZCBY6545EQMIDNQQZCOY5G"
var server = new StellarSdk.Server(settings.horizonUrl, {allowHttp: true});

server.loadAccount(user_address)
  .then(account => {
    // Find the XLM balance
    const xlmBalance = account.balances.find(balance => balance.asset_type === 'native');

    console.log(`Your XLM balance: ${xlmBalance.balance}`);
  })
  .catch(error => {
    console.error('Error loading account:', error);
  });
```

You'll get a result like this:
```bash
Your XLM balance: 10000.0000000
```


## 4. Use our code

If you want to use our **code** in the [Token Playground's Repo](https://github.com/esteblock/token-playground/), you can just call our script with the `soroban-preview-10` docker containter

You can run it by: 

```bash
bash src/chapter8/use_XLM_native.sh 
```

Check all the code in the repo!


# What is next?
In this chapter we created a new Stellar account and we fund it with `10000` XLM and we managed to check it's balance in the classic way. In the next chapter we will check its balance using smart contracts in Soroban!

Are you ready?

___

This Playground chapter has been written by [@esteblock](https://github.com/esteblock/)