#!/bin/bash
set -e
source ./src/set_variables.sh $1 $2
ASSET_CODE=$3
NETWORK="$1"

echo "Using ASSET_CODE: $ASSET_CODE"

echo "Configure the soroban client to use a other-user secret"
OTHER_USER_SECRET=$(cat ./settings.json | jq -r '.receiverSecret' )
mkdir -p ".soroban/identities"
echo "secret_key = \"$OTHER_USER_SECRET\"" > ".soroban/identities/other-user.toml"

ARGS="--network $NETWORK --identity other-user"

echo Try to wrap the Stellar asset from another user
TOKEN_ID=$(soroban lab token wrap $ARGS --asset "$ASSET_CODE:$TOKEN_ADMIN_ADDRESS")
echo "Token wrapped succesfully with TOKEN_ID: $TOKEN_ID"

mkdir -p .soroban
echo -n "$TOKEN_ID" > .soroban/token_id

echo "Done"
