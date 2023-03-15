# token-playground

Read the Tutorial in https://token-playground.gitbook.io/

Token playground to learn how create and interact with Soroban and Stellar Classic Assets using Soroban 


Addresses, keys, RPC_URL and asset code in settings.json

## Open soroban rpc & soroban preview docker containters
We'll use `standalone`, but you can also use `futurenet`
```
./quickstart.sh standalone
```
## Fund with friendbot
```
docker exec soroban-preview-7 node src/friendbot.js
```
## Issue an Asset:
1. Set yout keys and asset code in `settings.json`

```
docker exec soroban-preview-7 node src/issueAsset.js
```
TODO: make this script run in the soroban-preview docker container
`docker exec soroban-preview node src/issueAsset.js `. Check issue [#3](https://github.com/esteblock/token-playground/issues/3)

## Get info about the token
```
docker exec soroban-preview-7 node src/getInfo.js

```

## Wrap the token
```

docker exec soroban-preview-7 ./src/wrap.sh standalone using_docker
```


## Mint the token
```

docker exec soroban-preview-7 ./src/mint.sh standalone using_docker
```
In a simpler version:

```

docker exec soroban-preview-7 ./src/mint_with_just_token_id.sh standalone using_docker
```

## Get all contract id from issuer
```
docker exec soroban-preview-7 node  src/getAllAssetClassicContractIdFromIssuer.js
```

## Try to wrap the asset from another address
What happens if another user wants to wrap another's person asset?
In order to try this we need to issue a new asset. 
This is beacause we have already wrapped our asset. Otherwise it will fail anyways.

In this example our new asset code will be "TOKENNEW"
```
docker exec soroban-preview-7 node src/issueAsset.js TOKENNEW
docker exec soroban-preview-7 node src/getInfo.js TOKENNEW
docker exec soroban-preview-7 ./src/wrap_other.sh standalone using_docker TOKENNEW
docker exec soroban-preview-7 ./src/mint_with_just_token_id.sh standalone using_docker
docker exec soroban-preview-7 node src/getInfo.js TOKENNEW
```

## Get contract information from the soroban contract
Name, symbol, decimals and balance of receiver.
Should be the sum of issued in Classic and in Soroban
```
docker exec soroban-preview-7 ./src/get_token_info.sh standalone using_docker
```

## Send total assets from receiver
Receiver has received assets both in classic and in soroban
If we ask to the wrapped asset contract it's balance, it does shows the sum of both minted in classic and soroban.
Can it send that total amount to a third party inside Soroban?

TODO:    0: "trustline missing"
```
 docker exec soroban-preview-7 ./src/send_to_third.sh standalone using_docker
```


