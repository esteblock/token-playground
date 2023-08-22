soroban config identity generate my-account
MY_ACCOUNT_ADDRESS="$(soroban config identity address my-account)"
SOROBAN_RPC_HOST="http://stellar:8000"
FRIENDBOT_URL="$SOROBAN_RPC_HOST/friendbot"
curl  --silent -X POST "$FRIENDBOT_URL?addr=$MY_ACCOUNT_ADDRESS"  > /dev/null

node /workspace/src/chapter12/getInfoXLM.js $MY_ACCOUNT_ADDRESS