#!/bin/bash
set -e
source ./src/set_variables.sh $1 $2

NETWORK="$1"
 
echo "Configure the soroban client"
TOKEN_ADMIN_SECRET=$(cat ./settings.json | jq -r '.issuerSecret' )
# Check if the configured token-admin identity exist
if !(soroban config identity ls | grep token-admin 2>&1 >/dev/null); then
  echo Create the token-admin identity
  # TODO: Use `soroban config identity generate` once that supports secret key
  # output.
  # See: https://github.com/stellar/soroban-example-dapp/issues/88
  mkdir -p ".soroban/identity"
  echo "secret_key = \"$TOKEN_ADMIN_SECRET\"" > ".soroban/identity/token-admin.toml"
fi
TOKEN_ADMIN_SECRET="$(soroban config identity show token-admin)"
TOKEN_ADMIN_ADDRESS="$(soroban config identity address token-admin)"

echo "We are using the following TOKEN_ADMIN_ADDRESS: $TOKEN_ADMIN_ADDRESS"

ARGS="--network $NETWORK --source token-admin"

echo Wrap the Stellar asset
TOKEN_ADDRESS=$(soroban lab token wrap $ARGS --asset "$ASSET_CODE:$TOKEN_ADMIN_ADDRESS")
echo "Token wrapped succesfully with TOKEN_ADDRESS: $TOKEN_ADDRESS"

mkdir -p .soroban
echo -n "$TOKEN_ADDRESS" > .soroban/token_address

echo "Done"
