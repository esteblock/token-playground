#!/bin/bash
NETWORK="$1"
IS_USING_DOCKER="$2"

echo "Setting Variables"
ASSET_CODE=$([[ ! -z "$3" ]] && echo  $3 ||  cat ./settings.json | jq -r '.assetCode' )
DESTINATION_ADDRESS=$(cat ./settings.json | jq  -r '.receiverPublic' )
TOKEN_ADMIN_SECRET=$(cat ./settings.json | jq -r '.issuerSecret' )

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