
NETWORK="standalone"
SOROBAN_RPC_HOST="http://stellar:8000"
SOROBAN_RPC_URL="$SOROBAN_RPC_HOST/soroban/rpc"
FRIENDBOT_URL="$SOROBAN_RPC_HOST/friendbot"
SOROBAN_NETWORK_PASSPHRASE="Standalone Network ; February 2017"

echo Adding network
soroban config network add "$NETWORK" \
  --rpc-url "$SOROBAN_RPC_URL" \
  --network-passphrase "$SOROBAN_NETWORK_PASSPHRASE"
echo ---

echo Adding identity
soroban config identity generate my-account
MY_ACCOUNT_ADDRESS="$(soroban config identity address my-account)"
echo Identity added with my-account: $MY_ACCOUNT_ADDRESS
echo ---


echo Fund token-admin account from friendbot
curl  -X POST "$FRIENDBOT_URL?addr=$MY_ACCOUNT_ADDRESS"
echo ---

ARGS="--network standalone --source-account my-account"

echo Wrapping token
TOKEN_ADDRESS=$(soroban lab token wrap $ARGS --asset native)
echo Wrapped with address result: $TOKEN_ADDRESS
echo ---

echo Wrapping might fail if it was done before, so we are also getting the address:
TOKEN_ADDRESS="$(soroban lab token id --asset native --network standalone)"
echo Native token address: $TOKEN_ADDRESS
echo ---

# echo Building the token contract in order to have its WASM
# cd src/contracts/token
# make build
# TOKEN_WASM="/workspace/src/contracts/token/target/wasm32-unknown-unknown/release/soroban_token_contract.wasm"
# echo ---


echo Asking the native tokens contract what is my-account balance:
MY_BALANCE=$(soroban contract invoke \
  $ARGS \
  --id "$TOKEN_ADDRESS" \
  -- \
  balance \
  --id $MY_ACCOUNT_ADDRESS)
echo my-account XLM balance: $MY_BALANCE


echo Asking the native tokens contract what is its name
soroban contract invoke \
  $ARGS \
  --id "$TOKEN_ADDRESS" \
  -- \
  name

