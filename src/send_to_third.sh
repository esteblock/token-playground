#!/bin/bash
set -e
source ./src/set_variables.sh $1 $2
NETWORK="$1"
echo "Configure the soroban client to the receiver-user secret"
RECEIVER_SECRET=$(cat ./settings.json | jq -r '.receiverSecret' )
mkdir -p ".soroban/identities"

echo "secret_key = \"$RECEIVER_SECRET\"" > ".soroban/identities/receiver-user.toml"

ARGS="--network $NETWORK --identity receiver-user"

echo Check receiver-user total balance
RECEIVER_PUBLIC=$(cat ./settings.json | jq -r '.receiverPublic' )
TOKEN_ID=$(cat .soroban/token_id)
echo "Token id: $TOKEN_ID"

TOTAL_AMOUNT=$(soroban contract invoke \
  $ARGS \
  --wasm src/contracts/token/soroban_token_spec.wasm \
  --id "$TOKEN_ID" \
  --fn balance -- \
  --id "$RECEIVER_PUBLIC" )
TOTAL_AMOUNT=$(echo $TOTAL_AMOUNT | tr -d \")

echo "Receiver Balance is: $TOTAL_AMOUNT"

THIRD_PARTY_PUBLIC=$(cat ./settings.json | jq -r '.thirdParty' )
echo "Now will send this balance to a third party $THIRD_PARTY_PUBLIC"
soroban contract invoke \
  $ARGS \
  --wasm src/contracts/token/soroban_token_spec.wasm \
  --id "$TOKEN_ID" \
  --fn xfer -- \
  --from "$RECEIVER_PUBLIC" \
  --to "$THIRD_PARTY_PUBLIC" \
  --amount $TOTAL_AMOUNT 

