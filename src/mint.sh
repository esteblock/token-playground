#!/bin/bash

set -e

NETWORK="$1"
IS_USING_DOCKER="$2"

ASSET_CODE=$([[ ! -z "$3" ]] && echo  $3 ||  cat ../settings.json | jq -r '.assetCode' )
DESTINATION_ADDRESS=$(cat ../settings.json | jq  -r '.receiverPublic' )
TOKEN_ADMIN_SECRET=$(cat ../settings.json | jq -r '.issuerSecret' )


echo "Using asset code $ASSET_CODE"

# If soroban-cli is called inside the soroban-preview docker containter,
# it can call the stellar standalone container just using its name "stellar"

case "$2" in
using_docker)
  SOROBAN_RPC_HOST="http://stellar:8000"
  ;;
*)
  SOROBAN_RPC_HOST="http://localhost:8000"
  ;;
esac

SOROBAN_RPC_URL="$SOROBAN_RPC_HOST/soroban/rpc"

case "$1" in
standalone)
  echo "Using standalone network"
  SOROBAN_NETWORK_PASSPHRASE="Standalone Network ; February 2017"
  FRIENDBOT_URL="$SOROBAN_RPC_HOST/friendbot"
  ;;
futurenet)
  echo "Using Futurenet network"
  SOROBAN_NETWORK_PASSPHRASE="Test SDF Future Network ; October 2022"
  FRIENDBOT_URL="https://friendbot-futurenet.stellar.org/"
  ;;
*)
  echo "Usage: $0 standalone|futurenet"
  exit 1
  ;;
esac

TOKEN_ADMIN_ADDRESS="$(soroban config identity address token-admin)"

# This will fail if the account already exists, but it'll still be fine.
echo Fund token-admin account from friendbot
curl --silent -X POST "$FRIENDBOT_URL?addr=$TOKEN_ADMIN_ADDRESS" >/dev/null

ARGS="--network $NETWORK --identity token-admin"

TOKEN_ID=$(cat .soroban/token_id)

echo Build the sac contract
make build

echo Deploy the sac contract
SAC_ID="$(
  soroban contract deploy $ARGS \
    --wasm target/wasm32-unknown-unknown/release/soroban_sac_contract.wasm
)"
echo "$SAC_ID" > .soroban/sac_id

echo "Contract deployed succesfully with ID: $SAC_ID"

echo "Mint by transfer from issuer account using the sac contract"


soroban contract invoke \
  $ARGS \
  --wasm target/wasm32-unknown-unknown/release/soroban_sac_contract.wasm \
  --id "$SAC_ID" \
  --fn transfer -- \
  --user "$TOKEN_ADMIN_ADDRESS" \
  --amount "50000000" \
  --dest \"$DESTINATION_ADDRESS\" \
  --asset "$TOKEN_ID"

echo "Done"
