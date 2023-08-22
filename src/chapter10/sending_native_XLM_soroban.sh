
echo Creating a new identity
soroban config identity generate recipient
RECIPIENT="$(soroban config identity address recipient)"
echo Identity added with recipient: $RECIPIENT
echo ---

echo Creating the RECIPIENT account using Friendbot
curl  -X POST "$FRIENDBOT_URL?addr=$RECIPIENT"


echo Checking initial RECIPIENT balance
RECIPIENT_BALANCE=$(soroban contract invoke \
  $ARGS \
  --wasm $TOKEN_WASM \
  --id "$TOKEN_ADDRESS" \
  -- \
  balance \
  --id $MY_ACCOUNT_ADDRESS)
echo recipient original XLM balance: $RECIPIENT_BALANCE

echo Sending some love
soroban config identity generate my-account
MY_ACCOUNT_ADDRESS="$(soroban config identity address my-account)"
echo Identity added with my-account: $MY_ACCOUNT_ADDRESS
soroban contract invoke \
  --network standalone --source-account my-account \
  --wasm $TOKEN_WASM \
  --id "$TOKEN_ADDRESS" \
  -- \
  transfer \
  --from $MY_ACCOUNT_ADDRESS \
  --to $RECIPIENT