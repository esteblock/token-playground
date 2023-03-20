# Token Playground Chapter 6 : Wrap a token from Stellar Classic to Soroban.

## Introduction

In the previous chapters we have managed to issue Stellar Assets in the Stellar Classic blockchain.
In this chapter we will wrap that Stellar Asset into a Soroban token inside Soroban.

Remember to **follow the code** in the [Token Playground's Repo](https://github.com/esteblock/token-playground/)

## Setting up your soroban-cli
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
secret_key=
```



In this Playground we have our secrets in the `./settings.json` file, hence we will do:


```
TOKEN_ADMIN_SECRET=$(cat ./settings.json | jq -r '.issuerSecret' )
mkdir -p ".soroban/identities"
echo "secret_key = \"$TOKEN_ADMIN_SECRET\"" > ".soroban/identities/token-admin.toml"
```

echo "Configure the soroban client"
TOKEN_ADMIN_SECRET=$(cat ./settings.json | jq -r '.issuerSecret' )
# Check if the configured token-admin identity exist
if !(soroban config identity ls | grep token-admin 2>&1 >/dev/null); then
  echo Create the token-admin identity
  # TODO: Use `soroban config identity generate` once that supports secret key
  # output.
  # See: https://github.com/stellar/soroban-example-dapp/issues/88
  mkdir -p ".soroban/identities"
  echo "secret_key = \"$TOKEN_ADMIN_SECRET\"" > ".soroban/identities/token-admin.toml"
fi
TOKEN_ADMIN_ADDRESS="$(soroban config identity address token-admin)"


ARGS="--network $NETWORK --identity token-admin"
```
