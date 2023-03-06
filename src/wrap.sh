#!/bin/bash

set -e

NETWORK="$1"
IS_USING_DOCKER="$2"
ASSET_CODE=$(cat settings.json |jq '.assetCode' | tr -d "\"")
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

#if !(soroban config network ls | grep "$NETWORK" 2>&1 >/dev/null); then
# Always set a net configuration 
  echo Add the $NETWORK network to cli client
  soroban config network add "$NETWORK" \
    --rpc-url "$SOROBAN_RPC_URL" \
    --network-passphrase "$SOROBAN_NETWORK_PASSPHRASE"
#fi

TOKEN_ADMIN_SECRET="SAHC723FQTC3MARBNUZLUFEIYI62VQDQH7FHLD2FGV6GROQQ7ULMHQGH"
if !(soroban config identity ls | grep token-admin 2>&1 >/dev/null); then
  echo Create the token-admin identity
  # TODO: Use `soroban config identity generate` once that supports secret key
  # output.
  # See: https://github.com/stellar/soroban-example-dapp/issues/88
  mkdir -p ".soroban/identities"
  echo "secret_key = \"$TOKEN_ADMIN_SECRET\"" > ".soroban/identities/token-admin.toml"
fi
TOKEN_ADMIN_ADDRESS="$(soroban config identity address token-admin)"

# TODO: Remove this once we can use `soroban config identity` from webpack.
echo "$TOKEN_ADMIN_SECRET" > .soroban/token_admin_secret
echo "$TOKEN_ADMIN_ADDRESS" > .soroban/token_admin_address

# This will fail if the account already exists, but it'll still be fine.
echo Fund token-admin account from friendbot
curl --silent -X POST "$FRIENDBOT_URL?addr=$TOKEN_ADMIN_ADDRESS" >/dev/null

ARGS="--network $NETWORK --identity token-admin"

echo Wrap the Stellar asset
mkdir -p .soroban
TOKEN_ID=$(soroban lab token wrap $ARGS --asset "$ASSET_CODE:$TOKEN_ADMIN_ADDRESS")
echo "Token wrapped succesfully with TOKEN_ID: $TOKEN_ID"

echo -n "$TOKEN_ID" > .soroban/token_id

echo "Done"
