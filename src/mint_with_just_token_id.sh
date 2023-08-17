#!/bin/bash
set -e
source ./src/set_variables.sh $1 $2

NETWORK="$1"
ARGS="--network $NETWORK --source token-admin"
TOKEN_ADDRESS=$(cat .soroban/token_address)

echo "Mint 5 units of $ASSET_CODE"
echo "Minting to: $DESTINATION_ADDRESS"
echo "Using TOKEN_ADDRESS: $TOKEN_ADDRESS" 

soroban contract invoke \
  $ARGS \
  --wasm src/contracts/token/soroban_token_spec.wasm \
  --id "$TOKEN_ADDRESS" \
  -- \
  xfer \
  --from "$TOKEN_ADMIN_ADDRESS" \
  --to "$DESTINATION_ADDRESS" \
  --amount "50000000" 
