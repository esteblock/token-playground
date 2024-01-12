# Token Playground Chapter 14 : Wrapping other issuers assets.
Can we wrap other issuers assets? Even if those assets do not exist yet?


## 1. Wrap an unexisting asset using the SDK
We know we can **calculate** the contract ID, even if the asset or issuer does not exist
```bash
bash quickstart.sh standalone
bash run.sh
#node src/friendbot.js
node src/chapter13/checkAssetWrappedID.js ABC GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI
```

## 2. Wrap an unexisting asset using the CLI
From chapter 6 we know that we must do 
```
soroban lab token wrap --network standalone --source token-admin --asset "ASSET_CODE:ISSUER_ADDRESS"
```

## 3. Trying to wrap using CLI without funds:
If we try to wrap without funds, fails. This means that we are writing into the blockchain

```bash
bash quickstart.sh standalone
bash run.sh
SOROBAN_RPC_HOST="http://stellar:8000"
SOROBAN_RPC_URL="$SOROBAN_RPC_HOST/soroban/rpc"
echo Add the $NETWORK network to cli client
  soroban config network add "$NETWORK" \
    --rpc-url "$SOROBAN_RPC_URL" \
    --network-passphrase "$SOROBAN_NETWORK_PASSPHRASE"

soroban lab token wrap --network standalone --asset \
"ABC:GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI"
```
## 4- Wrapping with funds, we can wrap for any issuer, and any symbol.

```bash
bash quickstart.sh standalone
bash run.sh
SOROBAN_RPC_HOST="http://stellar:8000"
SOROBAN_RPC_URL="$SOROBAN_RPC_HOST/soroban/rpc"
FRIENDBOT_URL="$SOROBAN_RPC_HOST/friendbot"

echo Add the $NETWORK network to cli client
  soroban config network add "$NETWORK" \
    --rpc-url "$SOROBAN_RPC_URL" \
    --network-passphrase "$SOROBAN_NETWORK_PASSPHRASE"

soroban config identity generate user
USER="$(soroban config identity address user)"

curl  -X POST "$FRIENDBOT_URL?addr=$USER"


soroban lab token wrap --network standalone --source user  --asset  \
"ABC:GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI"
```

This gives us result:
```
CDMQFQUVCQ5DYD6Y4HKQYCRSX4YOYB6HSZD3GP6WWXWEEYUTV7JINUNK
```
Which is the contract that was created... In fact, we can know that the contract was created by doing:
```bash
soroban contract invoke \
  --network standalone --source user \
  --id CDMQFQUVCQ5DYD6Y4HKQYCRSX4YOYB6HSZD3GP6WWXWEEYUTV7JINUNK \
  -- \
  admin
```
We have as answer:
```
"GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI"

```
If we call:
```
soroban contract invoke \
  --network standalone --source user \
  --id CDMQFQUVCQ5DYD6Y4HKQYCRSX4YOYB6HSZD3GP6WWXWEEYUTV7JINUNK \
  -- \
  balance \
  --id GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI
```

We get: 
```
"9223372036854775807"
```
Which is u64 MAX... The admin has the maximum amount of tokens:


# Let's try on testnet


```bash
bash quickstart.sh standalone
bash run.sh
NETWORK="testnet"
SOROBAN_NETWORK_PASSPHRASE="Test SDF Network ; September 2015"
FRIENDBOT_URL="https://friendbot.stellar.org/"
SOROBAN_RPC_URL="https://soroban-testnet.stellar.org/"

echo Add the $NETWORK network to cli client
  soroban config network add "$NETWORK" \
    --rpc-url "$SOROBAN_RPC_URL" \
    --network-passphrase "$SOROBAN_NETWORK_PASSPHRASE"

soroban config identity generate user
USER="$(soroban config identity address user)"

curl  -X POST "$FRIENDBOT_URL?addr=$USER"


soroban lab token wrap --network testnet --source user  --asset  \
"ABC:GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI"
```

Now we have `CDHBGA3QDSZUHF4MIW6Q2KUONBHN5AXTUV6HDQSC2JZ54CRL6XJILKRD`.

Neither in Stellar Expert, neither StellarChain we have any info:
- https://stellar.expert/explorer/testnet/search?term=CDHBGA3QDSZUHF4MIW6Q2KUONBHN5AXTUV6HDQSC2JZ54CRL6XJILKRD
- https://testnet.stellarchain.io/contracts/CDHBGA3QDSZUHF4MIW6Q2KUONBHN5AXTUV6HDQSC2JZ54CRL6XJILKRD

However, if we check the user address: https://testnet.stellarchain.io/accounts/GAPSUQFLOYBPBGMFOMFLU47F6O572UVGZH3MLPNEHYK7NFOVLS5B35IA

We get the transaction.

..... If we try to do it again, we have the `Error(Storage, ExistingValue)` error, because the wrapped token contract already exist

Can we rely on this explorer information? 

## Using another issuer

We can try with the issuer of testnet USDC: https://stellar.expert/explorer/testnet/asset/USDC-GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5
Issuer: `GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5`

```
soroban lab token wrap --network testnet --source user  --asset  \
"USDC:GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5"
```
we get `CBIELTK6YBZJU5UP2WWQEUCYKLPU6AUNZ2BQ4WWFEIE3USCIHMXQDAMA`

## Can we "make create" an issuer an unwanted token?
We can do:
```
soroban lab token wrap --network testnet --source user  --asset  \
"ABBA:GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5"
```

With result:
```bash
CCW76FZLZI7O4ZTQ3EA2KCVDU3JYT4CYPAEFTJZGXM47VCG6UXAH4SM6
```

My user was: `GDTYRUGTHDU4WEC7EPFKE5GJDNLOBYEQFHFE5C42MTUGUBS3SEIWLKLA`
I can check in https://testnet.stellarchain.io/accounts/GDTYRUGTHDU4WEC7EPFKE5GJDNLOBYEQFHFE5C42MTUGUBS3SEIWLKLA

That I can see the transaction: https://testnet.stellarchain.io/operations/14925011357697
and that the contract was already deployed in https://testnet.stellarchain.io/transactions/b34ed4ad450270935c09547c23563793cd677fd05ea215c68082634c69115979


I can ask Horizon about this token:
`https://horizon-testnet.stellar.org/assets?asset_code=ABBA&asset_issuer=GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5`

```json
{
  "_links": {
    "self": {
      "href": "https://horizon-testnet.stellar.org/assets?asset_code=ABBA\u0026cursor=\u0026limit=10\u0026order=asc"
    },
    "next": {
      "href": "https://horizon-testnet.stellar.org/assets?asset_code=ABBA\u0026cursor=ABBA_GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5_credit_alphanum4\u0026limit=10\u0026order=asc"
    },
    "prev": {
      "href": "https://horizon-testnet.stellar.org/assets?asset_code=ABBA\u0026cursor=ABBA_GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5_credit_alphanum4\u0026limit=10\u0026order=desc"
    }
  },
  "_embedded": {
    "records": [
      {
        "_links": {
          "toml": {
            "href": "https://centre.io/.well-known/stellar.toml"
          }
        },
        "asset_type": "credit_alphanum4",
        "asset_code": "ABBA",
        "asset_issuer": "GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5",
        "paging_token": "ABBA_GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5_credit_alphanum4",
        "contract_id": "CCW76FZLZI7O4ZTQ3EA2KCVDU3JYT4CYPAEFTJZGXM47VCG6UXAH4SM6",
        "num_accounts": 0,
        "num_claimable_balances": 0,
        "num_liquidity_pools": 0,
        "num_contracts": 0,
        "num_archived_contracts": 0,
        "amount": "0.0000000",
        "accounts": {
          "authorized": 0,
          "authorized_to_maintain_liabilities": 0,
          "unauthorized": 0
        },
        "claimable_balances_amount": "0.0000000",
        "liquidity_pools_amount": "0.0000000",
        "contracts_amount": "0.0000000",
        "archived_contracts_amount": "0.0000000",
        "balances": {
          "authorized": "0.0000000",
          "authorized_to_maintain_liabilities": "0.0000000",
          "unauthorized": "0.0000000"
        },
        "flags": {
          "auth_required": false,
          "auth_revocable": false,
          "auth_immutable": false,
          "auth_clawback_enabled": false
        }
      }
    ]
  }
}

```

If we do:

```
node src/chapter14/getInfo.js ABBA 
```

We get:
```
server:  Server {
  serverURL: URI {
    _string: '',
    _parts: {
      protocol: 'https',
      username: null,
      password: null,
      hostname: 'horizon-testnet.stellar.org',
      urn: null,
      port: null,
      path: '/',
      query: null,
      fragment: null,
      preventInvalidHostname: false,
      duplicateQueryParameters: false,
      escapeQuerySpace: true
    },
    _deferred_build: true
  }
}
{
  _links: { toml: { href: 'https://centre.io/.well-known/stellar.toml' } },
  asset_type: 'credit_alphanum4',
  asset_code: 'ABBA',
  asset_issuer: 'GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5',
  paging_token: 'ABBA_GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5_credit_alphanum4',
  contract_id: 'CCW76FZLZI7O4ZTQ3EA2KCVDU3JYT4CYPAEFTJZGXM47VCG6UXAH4SM6',
  num_accounts: 0,
  num_claimable_balances: 0,
  num_liquidity_pools: 0,
  num_contracts: 0,
  num_archived_contracts: 0,
  amount: '0.0000000',
  accounts: {
    authorized: 0,
    authorized_to_maintain_liabilities: 0,
    unauthorized: 0
  },
  claimable_balances_amount: '0.0000000',
  liquidity_pools_amount: '0.0000000',
  contracts_amount: '0.0000000',
  archived_contracts_amount: '0.0000000',
  balances: {
    authorized: '0.0000000',
    authorized_to_maintain_liabilities: '0.0000000',
    unauthorized: '0.0000000'
  },
  flags: {
    auth_required: false,
    auth_revocable: false,
    auth_immutable: false,
    auth_clawback_enabled: false
  },
  toml: [Function (anonymous)]
}
root@34818ae2017f:/workspace# curl https://horizon-testnet.stellar.org/assets?asset_code=ABBA&asset_issuer=GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5
[1] 1147
root@34818ae2017f:/workspace# {
  "_links": {
    "self": {
      "href": "https://horizon-testnet.stellar.org/assets?asset_code=ABBA\u0026cursor=\u0026limit=10\u0026order=asc"
    },
    "next": {
      "href": "https://horizon-testnet.stellar.org/assets?asset_code=ABBA\u0026cursor=ABBA_GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5_credit_alphanum4\u0026limit=10\u0026order=asc"
    },
    "prev": {
      "href": "https://horizon-testnet.stellar.org/assets?asset_code=ABBA\u0026cursor=ABBA_GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5_credit_alphanum4\u0026limit=10\u0026order=desc"
    }
  },
  "_embedded": {
    "records": [
      {
        "_links": {
          "toml": {
            "href": "https://centre.io/.well-known/stellar.toml"
          }
        },
        "asset_type": "credit_alphanum4",
        "asset_code": "ABBA",
        "asset_issuer": "GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5",
        "paging_token": "ABBA_GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5_credit_alphanum4",
        "contract_id": "CCW76FZLZI7O4ZTQ3EA2KCVDU3JYT4CYPAEFTJZGXM47VCG6UXAH4SM6",
        "num_accounts": 0,
        "num_claimable_balances": 0,
        "num_liquidity_pools": 0,
        "num_contracts": 0,
        "num_archived_contracts": 0,
        "amount": "0.0000000",
        "accounts": {
          "authorized": 0,
          "authorized_to_maintain_liabilities": 0,
          "unauthorized": 0
        },
        "claimable_balances_amount": "0.0000000",
        "liquidity_pools_amount": "0.0000000",
        "contracts_amount": "0.0000000",
        "archived_contracts_amount": "0.0000000",
        "balances": {
          "authorized": "0.0000000",
          "authorized_to_maintain_liabilities": "0.0000000",
          "unauthorized": "0.0000000"
        },
        "flags": {
          "auth_required": false,
          "auth_revocable": false,
          "auth_immutable": false,
          "auth_clawback_enabled": false
        }
      }
    ]
  }

```


It's very strange that in Horizon we get that balances are 0

If we check how much the USDC issuer has of USDC:
```
soroban contract invoke \
  --network testnet --source user \
  --id CBIELTK6YBZJU5UP2WWQEUCYKLPU6AUNZ2BQ4WWFEIE3USCIHMXQDAMA \
  -- \
  balance \
  --id GBBD47IF6LWK7P7MDEVSCWR7DPUWV3NY3DTQEVFL4NAT4AQH3ZLLFLA5
```

Is allways u64 MAX less the balance minted.....
Strange?


## See if the contract exist
We might call to a "balance" function and see if this fails?

##