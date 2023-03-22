# Token Playground Chapter 3 : Environment preparation

- Check this guide in [https://token-playground.gitbook.io/](https://token-playground.gitbook.io/)
- Edit this guide in it's repo: [https://github.com/esteblock/token-playground/](https://github.com/esteblock/token-playground/)
- Contribute to this guide in the [./docs folder](https://github.com/esteblock/token-playground/tree/main/docs) of the repo

## 1. Configure Docker

In this playground Docker containters are used for two things.
1.- to run the standalone soroban network
2.- to run the soroban-preview docker container.

The [soroban-preview docker container](https://github.com/esteblock/soroban-preview-docker) allow developers to work in different projects that use different [Soroban Preview Releases](https://soroban.stellar.org/docs/reference/releases) (with different versions of soroban-cli, rust and others)

Here we detail the steps to follow in order to install your Docker envirenoment:

-  Install Docker in your system
-  Create a common docker network 
-  Run docker container soroban-preview, that includes soroban cli, rust and others
-  Create two stellar address accounts (isser and destination address)
-  Configure setting.json    

Remember to **follow the code** in the [Token Playground's Repo](https://github.com/esteblock/token-playground/)


### 1.1. Create a common docker network (only once) 

```
docker network create soroban-network
```

### 1.2. Run a Docker soroban-preview container:

The soroban-preview docke images are hosted in [docker hub](https://hub.docker.com/r/esteblock/soroban-preview/tags). In this example we will use the `esteblock/soroban-preview:7` image. To run, do:

```
currentDir=$(pwd)
docker run --volume  ${currentDir}:/workspace \
           --name soroban-preview-7 \
           --interactive \
           --tty \
           -p 8001:8000 \
           --detach \
           --ipc=host \
           --network soroban-network \
           esteblock/soroban-preview:7
```

### 1.3.- Run a Docker stellar/quickstart container

Stellar provides a docker image that contains an stellar node including Soroban, an stellar core programm and horizon server. You can initialize the node as standalone (transactions will not be synced to the network), futurenet (transactions will be synced to futurenet network), or mainnet


You can get and run stellar/quickstart by executing 


```
docker run --rm -ti \
  --platform linux/amd64 \
  --name stellar \
  --network soroban-network \
  -p 8000:8000 \
  stellar/quickstart:soroban-dev@sha256:81c23da078c90d0ba220f8fc93414d0ea44608adc616988930529c58df278739 \
  standalone \
  --enable-soroban-rpc \
  --protocol-version 20 
```

### 1.4. Use the Playground code

In this playground we prepared the [quickstart.sh](https://github.com/esteblock/token-playground/blob/main/quickstart.sh) scipt that will do the previous steps for you. Just do.

```
./quickstart.sh standalone
```


## 1. Configure Two Stellar Accounts

You will need two stellar accounts to use this token playground. The first one will be the issuer address, responsible of creating and issuing Stellar Assets,  the second one wiil be the destination address that will need to create a trustline to the asset and then will receive the tokens.

You can use [the stellar laboratory](https://laboratory.stellar.org/#account-creator?network=futurenet) to create the accounts.  Stellar accounts need to be funded wit at least 1 xlm  before existing. Stellar provide the friendbot utility that can fund test networks like futurenet. 

Here is an example about how to fund and make an account exist:

```
TOKEN_ADMIN_ADDRESS="GCUA5RTRR4N4ILSMORG3XFXJZB6KRG4QB22Z45BUNO5LIBCOYYPZ6TPZ"
FRIENDBOT_URL="http://stellar:8000/soroban/rpc/friendbot"

#in case you're using futurenet  the friend bot  url should be http://stellar:8000/soroban/rpc/friendbot 

curl --silent -X POST "FRIENDBOT_URL?addr=TOKEN_ADMIN_ADDRESS" >/dev/null

```

if you want to use our **code** in the [Token Playground's Repo](https://github.com/esteblock/token-playground/), you can just call our script with the `soroban-preview-7` docker containter

```
docker exec soroban-preview-7 node src/friendbot.js
```

You will need to set up the two address in [seetings.json](https://github.com/esteblock/token-playground/blob/main/settings.json) to get the friendbot script run successfully. 



### 5.- Configure settings.js

The file [settings.json](https://github.com/esteblock/token-playground/blob/main/settings.json) include a set of variables required to run the different scripts of the token playground. Here you have a sample: 

```
{   "issuerSecret": "SAHC723FQTC3MARBNUZLUFEIYI62VQDQH7FHLD2FGV6GROQQ7ULMHQGH",   
    "issuerPublic": "GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI",    
    "receiverSecret": "SBFJKSFA5YK2SUAVVSMEKDA44MYCBFSNNAORJSO7J437HJWU6G7SGAVF",
    "receiverPublic": "GDGYEYETZ2AWW3M3XUEAZN7LZPCL4BTKROEDE5LLOU6GTJRNG4FX3IEQ",
    "thirdParty": "GBIZQR4QEOFHONNJAC72H2TYTMINJXNQ4J63VGCKT2X5VMJ4IQE3OWZM", 
    "assetCode": "MYASSETCODE", // assset code of the asset issued
    "horizonUrl": "http://stellar:8000", //url to request horizon api
    "networkPassphrase": "Standalone Network ; February 2017", 
    "amount": "5", //amount will be issued in asset creation
    "limit": "1000"  //limit ammount to  receive
}
```

___

This Playgound has been developed by [@esteblock](https://github.com/esteblock/) in collaboration with [@marcos74](https://github.com/marcos74) from [@Dogstarcoin](https://github.com/Dogstarcoin)

