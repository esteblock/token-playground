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
node src/friendbot.js
```
## Issue an Asset:
1. Set yout keys and asset code in `settings.json`

```
node src/issueAsset.js
```
TODO: make this script run in the soroban-preview docker container
`docker exec soroban-preview node src/issueAsset.js `. Check issue [#3](https://github.com/esteblock/token-playground/issues/3)

## Get info about the token
```
node src/getInfo.js

```

## Wrap the token
```

docker exec soroban-preview-7 ./src/wrap.sh standalone using_docker
```


## Mint the token
```

docker exec soroban-preview-7 ./src/mint.sh standalone using_docker
```