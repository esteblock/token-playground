#!/bin/bash

# fn decimals(e: Env) -> u32;
# fn name(e: Env) -> Bytes;
# fn symbol(e: Env) -> Bytes;

set -e
source ./src/set_variables.sh $1 $2

NETWORK="$1"
ARGS="--network $NETWORK --identity token-admin"
TOKEN_ID=$(cat .soroban/token_id)
echo "Token id: $TOKEN_ID"
echo "---"

echo "Getting name"
soroban contract invoke \
  $ARGS \
  --wasm src/contracts/token/soroban_token_spec.wasm \
  --id "$TOKEN_ID" \
  --fn name
echo "---"

echo "Getting symbol"
soroban contract invoke \
  $ARGS \
  --wasm src/contracts/token/soroban_token_spec.wasm \
  --id "$TOKEN_ID" \
  --fn symbol
echo "---"

echo "Getting decimals"
soroban contract invoke \
  $ARGS \
  --wasm src/contracts/token/soroban_token_spec.wasm \
  --id "$TOKEN_ID" \
  --fn decimals
echo "---"

echo "Getting balance of receiver"
#    fn balance(e: Env, id: Address) -> i128;
soroban contract invoke \
  $ARGS \
  --wasm src/contracts/token/soroban_token_spec.wasm \
  --id "$TOKEN_ID" \
  --fn balance -- \
  --id "$DESTINATION_ADDRESS"
echo "---"