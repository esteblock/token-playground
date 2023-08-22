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

soroban config identity generate my-account
MY_ACCOUNT_ADDRESS="$(soroban config identity address my-account)"
curl  --silent -X POST "$FRIENDBOT_URL?addr=$MY_ACCOUNT_ADDRESS" > /dev/null
ARGS="--network standalone --source-account my-account"

echo Wrapping token
TOKEN_ADDRESS=$(soroban lab token wrap $ARGS --asset native)
echo Wrapped with address result: $TOKEN_ADDRESS
echo ---

echo Wrapping might fail if it was done before, so we are also getting the address:
TOKEN_ADDRESS="$(soroban lab token id --asset native --network standalone)"
echo Native token address: $TOKEN_ADDRESS
echo ---

echo Creating my-account identity
soroban config identity generate my-account
MY_ACCOUNT_ADDRESS="$(soroban config identity address my-account)"
curl  --silent -X POST "$FRIENDBOT_URL?addr=$MY_ACCOUNT_ADDRESS" > /dev/null

echo Creating spender identity
soroban config identity generate spender
SPENDER="$(soroban config identity address spender)"
curl  --silent -X POST "$FRIENDBOT_URL?addr=$SPENDER" > /dev/null

echo Creating recipient identity
soroban config identity generate recipient
RECIPIENT="$(soroban config identity address recipient)"
curl  --silent -X POST "$FRIENDBOT_URL?addr=$RECIPIENT" > /dev/null

echo Checking initial balance of recipient
soroban contract invoke   --network standalone --source-account my-account  --id "$TOKEN_ADDRESS"   --   balance   --id $RECIPIENT

echo Sending 5 stroops from my-account to recipient
soroban contract invoke   --network standalone --source-account my-account  --id "$TOKEN_ADDRESS"   --   transfer   --from $MY_ACCOUNT_ADDRESS   --to $RECIPIENT  --amount 5

echo Checking new balance of recipient
soroban contract invoke   --network standalone --source-account my-account  --id "$TOKEN_ADDRESS"   --   balance   --id $RECIPIENT

echo Approve 5 stroops from my-account. spender will be the spender identity
soroban contract invoke   --network standalone --source-account my-account  --id "$TOKEN_ADDRESS"   --   approve   --from $MY_ACCOUNT_ADDRESS   --spender $SPENDER  --amount 5 --expiration-ledger 999999 

echo Checkint the allowance of spender to spend from my-account
soroban contract invoke   --network standalone --source-account my-account  --id "$TOKEN_ADDRESS"   --   allowance   --from $MY_ACCOUNT_ADDRESS   --spender $SPENDER

echo Checking recipient balance before doing the transfer_from
soroban contract invoke   --network standalone --source-account my-account  --id "$TOKEN_ADDRESS"   --   balance   --id $RECIPIENT

echo Executing the transfer_from function. Spender is spending 5 stroops. Sending from my-account to recipient
soroban contract invoke   --network standalone --source-account spender  --id "$TOKEN_ADDRESS"   --   transfer_from   --spender $SPENDER --from $MY_ACCOUNT_ADDRESS --to $RECIPIENT  --amount 5

echo Checking new balance of recipient
soroban contract invoke   --network standalone --source-account my-account  --id "$TOKEN_ADDRESS"   --   balance   --id $RECIPIENT


