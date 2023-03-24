# Token Playground Chapter 6 : Wrap a token from Stellar Classic to Soroban.

- Check this guide in [https://token-playground.gitbook.io/](https://token-playground.gitbook.io/)
- Edit this guide in it's repo: [https://github.com/esteblock/token-playground/](https://github.com/esteblock/token-playground/)
- Contribute to this guide in the [./docs folder](https://github.com/esteblock/token-playground/tree/main/docs) of the repo

## 1. Introduction

In the previous chapters we have managed to issue a (classic) Stellar Assets in the (classic) Stellar blockchain.
In this chapter we will **wrap** that **Stellar Asset** into a **Stellar Asset Contract (SAC)** token inside **Soroban**.

## 2. Setting up your soroban-cli

Before using the `soroban-cli`, we need to configure it by telling which account will be executing and signing the transactions. In order to do this, we will call the `soroban config identity` command and we will provide it with the account's private key.

Here we will suppose that our user is the token admin of the asset, so we will call it `token-admin`, but you can choose another name for this.

1. Setup your `.soroban/identities` folder

First create the folder if it does not exist yet

```bash 
mkdir -p ./soroban/identities
```
`soroban-cli` will read from here your identities. Inside this folder you'll need to create one file with `.toml` for every identity you want to have. If you want to have `user-name-1`, `user-name-2` and `user-name-3`. Your `.soroban/identities` folder should have 3 files and should look like this

```
.soroban/identities/user-name-1.toml
.soroban/identities/user-name-2.toml
.soroban/identities/user-name-3.toml
```
Where each `user-name-X` is a text file with the following structure:

```
secret_key=SBBSXWIML25UV46X3MPC7P4UZISJ2RCCTHHD6PUGRRVHPYLKNXXW2N4I
```

In this Playground we have our secrets in the `./settings.json` file, hence we will do:

```bash
TOKEN_ADMIN_SECRET=$(cat ./settings.json | jq -r '.issuerSecret' )
mkdir -p ".soroban/identities"
echo "secret_key = \"$TOKEN_ADMIN_SECRET\"" > ".soroban/identities/token-admin.toml"
```

2. Configure your soroban-cli to use the `token-admin` identity

```bash
soroban config identity address token-admin

```
## 3. Wrap your Stellar Asset into Soroban

For this you'll need the full Stellar Asset identification [read our chapter about Basic Concepts](2_basic_concepts.md). The asset identification is built by:

- The asset code (example: `USDC`)
- The issuer address (example: `GCUA5RTRR4N4ILSMORG3XFXJZB6KRG4QB22Z45BUNO5LIBCOYYPZ6TPZ`)

In order to wrap an asset you'll need to use the `soroban lab token wrap` command as follows:
```bash
soroban lab token wrap --network standalone --identity token-admin --asset "ASSET_CODE:ISSUER_ADDRESS"
```
where the `token-admin` identity is the identity of the user that will sign the transaction. We will see in a further chapter that this identity does not necessary needs to be the token admin itself.
This command will return the `id` of the SAC smart contract that will manage the wrapped token.

```
success
86b9acd9860d105c2b5e6b688ab0fce5f9c45516dcc704f9427936c79384e72f
``` 
This correspond to the contract id, a 32-byte byte arrays, represented by BytesN<32> 

## 4. Save the contract ID for further use!

The contract id of this Stellar Asset Contract that is wrapping your Stellar Asset is crucial in order to use the token inside Soroban, so be sure to save it in a safe place!

In order to do this, you can do:

```bash
TOKEN_ID=$(soroban lab token wrap $ARGS --asset "$ASSET_CODE:$ISSUER_ADDRESS")
echo "Token wrapped succesfully with TOKEN_ID: $TOKEN_ID"
echo -n "$TOKEN_ID" > .soroban/token_id
```

What happens if you did not saved the contract id? Don't worry, in [Chapter 9](9_get_all_contract_ids_from_an_issuer.md) we will show how to recover the contract id of an already wrapped Stellar Asset.

Here, you'll find a fragmet of the code that includes all steps and exemplifies how to wrap a Stellar Asset:

```bash
NETWORK="standalone"
ASSET_CODE="MY_ASSET"
TOKEN_ADMIN_ADDRESS="GCUA5RTRR4N4ILSMORG3XFXJZB6KRG4QB22Z45BUNO5LIBCOYYPZ6TPZ"

ARGS="--network $NETWORK --identity token-admin"
TOKEN_ID=$(soroban lab token wrap $ARGS --asset "$ASSET_CODE:$TOKEN_ADMIN_ADDRESS")
echo "Token wrapped succesfully with TOKEN_ID: $TOKEN_ID"

mkdir -p .soroban
echo -n "$TOKEN_ID" > .soroban/token_id
```
Another example, without the usage of `identity` can be:

```bash
soroban lab token wrap --asset="AstroDollar:GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI" --secret-key SAHC723FQTC3MARBNUZLUFEIYI62VQDQH7FHLD2FGV6GROQQ7ULMHQGH --rpc-url https://horizon-futurenet.stellar.cash:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022'
```

## 5. Use our code

If you want to use our **code** in the [Token Playground's Repo](https://github.com/esteblock/token-playground/), you can just call our script with the `soroban-preview-7` docker containter

You can run it by: 

```bash
docker exec soroban-preview-7 ./src/wrap.sh standalone using_docker
```

Check all the code of our `wrap.sh` script [here](https://github.com/esteblock/token-playground/blob/main/src/wrap.sh)


# Next?
In the next two chapters we will mint tokens inside Soroban from an already wrapped Stellar Asset using its SAC's contract id. Are you ready?

___

This Playground has been developed by [@esteblock](https://github.com/esteblock/) in collaboration with [@marcos74](https://github.com/marcos74) from [@Dogstarcoin](https://github.com/Dogstarcoin)
