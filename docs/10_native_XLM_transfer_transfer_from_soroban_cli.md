# Token Playground Chapter 10 : Write the native token (XLM) contract using soroban-cli


- Check this guide in [https://token-playground.gitbook.io/](https://token-playground.gitbook.io/)
- Edit this guide in it's repo: [https://github.com/esteblock/token-playground/](https://github.com/esteblock/token-playground/)
- Contribute to this guide in the [./docs folder](https://github.com/esteblock/token-playground/tree/main/docs) of the repo

## 1. Introduction
What about when we want to use XLM inside a Soroban smart contract? How do we trigger those transactions? Can we trigger transactions on behalf the user using the `require_auth` method?
 
In this chapter we will see how to interact and write (call functions that change the state of the Blockchain) the native token (XLM) smart contract inside Soroban using soroban-cli.

Specifically we will call the `transfer`, `approve` and `transfer_from` functions:

## 2. Setting up our environment
Configure `soroban-cli`, wrap the native token (see chapter 8) and get its address:

```bash
NETWORK="standalone"
SOROBAN_RPC_HOST="http://stellar:8000"
SOROBAN_RPC_URL="$SOROBAN_RPC_HOST/soroban/rpc"
FRIENDBOT_URL="$SOROBAN_RPC_HOST/friendbot"
SOROBAN_NETWORK_PASSPHRASE="Standalone Network ; February 2017"

echo Adding network
soroban config network add "$NETWORK" \
  --rpc-url "$SOROBAN_RPC_URL" \
  --network-passphrase "$SOROBAN_NETWORK_PASSPHRASE"
echo ---

soroban config identity generate my-account
MY_ACCOUNT_ADDRESS="$(soroban config identity address my-account)"
curl  --silent -X POST "$FRIENDBOT_URL?addr=$MY_ACCOUNT_ADDRESS" > null
ARGS="--network standalone --source-account my-account"

echo Wrapping token
TOKEN_ADDRESS=$(soroban lab token wrap $ARGS --asset native)
echo Wrapped with address result: $TOKEN_ADDRESS
echo ---

echo Wrapping might fail if it was done before, so we are also getting the address:
TOKEN_ADDRESS="$(soroban lab token id --asset native --network standalone)"
echo Native token address: $TOKEN_ADDRESS
echo ---

```

## 3. Setting up your identities
In this chapter we will use a `my-account`, `spender` and `recipient` accounts.
The `my-account` account will be the main account that will holds XLM and send them to the `recipient`. Also, the `my-account` will allow the `spender` to send XLM on his behalf:

```bash

echo Creating my-account identity
soroban config identity generate my-account
MY_ACCOUNT_ADDRESS="$(soroban config identity address my-account)"
curl  --silent -X POST "$FRIENDBOT_URL?addr=$MY_ACCOUNT_ADDRESS" > null

echo Creating spender identity
soroban config identity generate spender
SPENDER="$(soroban config identity address spender)"
curl  --silent -X POST "$FRIENDBOT_URL?addr=$SPENDER" > null

echo Creating recipient identity
soroban config identity generate recipient
RECIPIENT="$(soroban config identity address recipient)"
curl  --silent -X POST "$FRIENDBOT_URL?addr=$RECIPIENT" > null
```

## 4. Transfer XLM
1. Check the initial balance of the recipient
```bash
echo Checking initial balance of recipient
soroban contract invoke   --network standalone --source-account my-account  --id "$TOKEN_ADDRESS"   --   balance   --id $RECIPIENT
```
The result should be:
```bash
Checking initial balance of recipient
"100000000000"
```

2. Call the **transfer** function using my-account as source-account
```bash
echo Sending 5 stroops from my-account to recipient
soroban contract invoke   --network standalone --source-account my-account  --id "$TOKEN_ADDRESS"   --   transfer   --from $MY_ACCOUNT_ADDRESS   --to $RECIPIENT  --amount 5
```
3. Check the new balance of the recipient
```bash
echo Checking new balance of recipient
soroban contract invoke   --network standalone --source-account my-account  --id "$TOKEN_ADDRESS"   --   balance   --id $RECIPIENT
```

The result should be:
```bash
Checking new balance of recipient
"100000000005"
```

## 5. Using transfer_from
```bash
echo Approve 5 stroops from my-account. spender will be the spender identity
soroban contract invoke   --network standalone --source-account my-account  --id "$TOKEN_ADDRESS"   --   approve   --from $MY_ACCOUNT_ADDRESS   --spender $SPENDER  --amount 5 --expiration-ledger 999999 

echo Checkint the allowance of spender to spend from my-account
soroban contract invoke   --network standalone --source-account my-account  --id "$TOKEN_ADDRESS"   --   allowance   --from $MY_ACCOUNT_ADDRESS   --spender $SPENDER

echo Checking recipient balance before doing the transfer_from
soroban contract invoke   --network standalone --source-account my-account  --id "$TOKEN_ADDRESS"   --   balance   --id $RECIPIENT

echo Executing the transfer_from function. Spender is spending 5 stroops. Sending from my-account to recipient
soroban contract invoke   --network standalone --source-account spender  --id "$TOKEN_ADDRESS"   --   transfer_from   --spender $SPENDER --from $MY_ACCOUNT_ADDRESS --to $RECIPIENT  --amount 5

echo Checking new balance of recipient
soroban contract invoke   --network standalone --source-account my-account  --id "$TOKEN_ADDRESS"   --   balance   --id $RECIPIENT

```

The result should be:
```bash

```




