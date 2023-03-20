# Token Playground Chapter 6 : Wrap a token from Stellar Classic to Soroban.

## 1. Introduction

In the previous chapters we have managed to issue Stellar Assets in the Stellar Classic blockchain.
In this chapter we will wrap that Stellar Asset into a Soroban token inside Soroban.

Remember to **follow the code** in the [Token Playground's Repo](https://github.com/esteblock/token-playground/)

## 2. Setting up your soroban-cli
Before using the `soroban-cli`, we need to configure it by telling which account will be executing and signing the transactions. In order to do this, we will call the `soroban config identity` command.

As we suppose that our user is the token admin of the asset, we will call it "token-admin"

1. Create the `.soroban/identities` folder
`soroban-cli` will read from here your identities. Here you'll need to create one file for every identity you want to have. If you want to have `user-name-1`, `user-name-2` and `user-name-3`. Your `.soroban/identities` folder should have 3 files and should look like this

```
.soroban/identities/user-name-1
.soroban/identities/user-name-2
.soroban/identities/user-name-3
```
Where each `user-name-X` is a text file with the following structure:
```
secret_key=SBBSXWIML25UV46X3MPC7P4UZISJ2RCCTHHD6PUGRRVHPYLKNXXW2N4I
```

In this Playground we have our secrets in the `./settings.json` file, hence we will do:

```
TOKEN_ADMIN_SECRET=$(cat ./settings.json | jq -r '.issuerSecret' )
mkdir -p ".soroban/identities"
echo "secret_key = \"$TOKEN_ADMIN_SECRET\"" > ".soroban/identities/token-admin.toml"
```

2. Configure your soroban-cli

```
soroban config identity address token-admin

```
## 3. Wrap a Stellar Asset into Soroban
You'll need:
- The issuer address (example: ``)
- The asset code (example: `USDC`)

In orde to wrap an asset you'll need to use the `soroban lab token wrap` command as follows:
```
soroban lab token wrap --network standalone --identity token-admin --asset "$ASSET_CODE:$TOKEN_ADMIN_ADDRESS"
```
where the `token-admin` identity is the identity of the user that will sign the transaction. We will see in a further chapter that this identity does not necessary needs to be the token admin itself.
This command will return the `id` of the SAC smart contract that will manage the wrapped token.

```
success
86b9acd9860d105c2b5e6b688ab0fce5f9c45516dcc704f9427936c79384e72f
``` 
This  correspond to the contract id,a 32-byte byte arrays, represented by BytesN<32> 
## 5. Example andthe Playground's code
Here is an example:
```

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
```
soroban lab token wrap --asset="AstroDollar:GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI" --secret-key SAHC723FQTC3MARBNUZLUFEIYI62VQDQH7FHLD2FGV6GROQQ7ULMHQGH --rpc-url https://horizon-futurenet.stellar.cash:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022'

```
If you want to use our **code** in the [Token Playground's Repo](https://github.com/esteblock/token-playground/), you can just call our script with the `soroban-preview-7` docker containter
```
docker exec soroban-preview-7 ./src/wrap.sh standalone using_docker

```