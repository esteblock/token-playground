#!/bin/bash
set -e
source ./src/set_variables.sh $1 $2

NETWORK="$1"
ARGS="--network $NETWORK --identity token-admin"
TOKEN_ID=$(cat .soroban/token_id)

echo "Set the soroban identity as the token-admin"
soroban config identity address token-admin
echo "---"

echo "Mint 5 units of $ASSET_CODE"
echo "Minting to: $DESTINATION_ADDRESS"

soroban contract invoke \
  $ARGS \
  --wasm src/contracts/token/soroban_token_spec.wasm \
  --id "$TOKEN_ID" \
  --fn xfer -- \
  --from "$TOKEN_ADMIN_ADDRESS" \
  --to "$DESTINATION_ADDRESS" \
  --amount "50000000" 
