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
  mkdir -p ".soroban/identities"
  echo "secret_key = \"$TOKEN_ADMIN_SECRET\"" > ".soroban/identities/token-admin.toml"
fi
TOKEN_ADMIN_ADDRESS="$(soroban config identity address token-admin)"


ARGS="--network $NETWORK --identity token-admin"

echo Wrap the Stellar asset
TOKEN_ID=$(soroban lab token wrap $ARGS --asset "$ASSET_CODE:$TOKEN_ADMIN_ADDRESS")
echo "Token wrapped succesfully with TOKEN_ID: $TOKEN_ID"

mkdir -p .soroban
echo -n "$TOKEN_ID" > .soroban/token_id

echo "Done"
