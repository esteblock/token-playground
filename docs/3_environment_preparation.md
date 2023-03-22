# Token Playground Chapter 3 : Environment preparation

- Check this guide in [https://token-playground.gitbook.io/](https://token-playground.gitbook.io/)
- Edit this guide in it's repo: [https://github.com/esteblock/token-playground/](https://github.com/esteblock/token-playground/)
- Contribute to this guide in the [./docs folder](https://github.com/esteblock/token-playground/tree/main/docs) of the repo

# Introduction:
In this chapte we will prepare our system in order to use this Playground. You need to have **Docker** installed in  your system, configure at least 2 stellar accounts, and edit the `settings.js` file.

Remember to **follow the code** in the [Token Playground's Repo](https://github.com/esteblock/token-playground/). Also, you can clone the code by doing
```bash
git clone https://github.com/esteblock/token-playground/
```

# 1. Configure Docker

Here we detail the steps to follow in order to configure your Docker envirenoment:

-  Install Docker in your system. 
-  Create a common docker network 
-  Run a docker container with the **esteblock/soroban-preview** image, that includes soroban cli, rust and other tools that this [playground](https://github.com/esteblock/token-playground/) uses 
- Run a docker container with the **stellar/quickstart** image, that provides a local  stellar and soroban node

### 1.1. Install Docker in your system

Follow the instructions from the [Docker's web page](https://docs.docker.com/get-docker/)

### 1.2. Create a common docker network (only once) 

Create a common docker network will allow  the two docker containers that we will create in next steps communicate between each other.

Here we will name this network as `soroban-network`, but you can choose the name you want. You can create this network by: 

```
docker network create soroban-network
```

### 1.3. Run a soroban-preview docker container:


The [soroban-preview docker images](https://github.com/esteblock/soroban-preview-docker) allow developers to work in different projects that use different [Soroban Preview Releases](https://soroban.stellar.org/docs/reference/releases) (with different versions of soroban-cli, rust and others). [Read more here](https://dev.to/esteblock/docker-images-for-soroban-preview-releases-240d)
 
The soroban-preview docker images are hosted in [docker hub](https://hub.docker.com/r/esteblock/soroban-preview/tags). In this example we will use the Soroban Preview Release #7, hence we will use the `esteblock/soroban-preview:7` image. To run a container with this image, do:

```bash
cd token-playground
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

Here we used the flag `--network soroban-network`, so any other container in the same network can call each other just using its name. In this case, this container's name is `soroban-preview-7`

### 1.4.- Run a stellar/quickstart docker container

Stellar provides a docker image that contains an stellar node including Soroban, an stellar core program and the horizon server. You can initialize the node as standalone (transactions will not be synced to the network), futurenet (transactions will be synced to futurenet network), or mainnet.

You can run this container by doing:

```bash
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

Here we are using the `stellar/quickstart:soroban-dev@sha256:81c23da078c90d0ba220f8fc93414d0ea44608adc616988930529c58df278739` beacuse this is the image used in the [Soroban Preview #7](https://soroban.stellar.org/docs/reference/releases), and we are using the same network with the flag `--network soroban-network`

Then, if the `soroban-preview-7` containter want's to call the RPC of the `stellar` container, it can use the following RPC URL 
```bash
http://stellar:8000
``` 

### 1.4. Use the Playground code

In this playground we prepared the [quickstart.sh](https://github.com/esteblock/token-playground/blob/main/quickstart.sh) scipt that will do steps 1.2, 1.3 and 1.4. Just do.

```bash
./quickstart.sh standalone
```


# 2. Configure Two Stellar Accounts

### 2.1. Get two new accounts from the Stellar Laboratory

You will need two stellar accounts to use this token playground. The first one will be the receiver address, responsible of creating and issuing Stellar Assets,  the second one wiil be the destination address that will need to create a trustline to the asset and then will receive the tokens.

You can use [the stellar laboratory](https://laboratory.stellar.org/#account-creator?network=futurenet) to create the accounts. 

### 2.2. Configure settings.js

The file [settings.json](https://github.com/esteblock/token-playground/blob/main/settings.json) include a set of variables required to run the different scripts of the token playground. Here you have a sample: 

```json
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

Here, you need to edit:
- For the issuer account: `issuerSecret` and `issuerPublic`
- For the receiver account: `receiverSecret` and `receiverPublic`.

`thirdParty` will be configured later...  or  you can leave it like this


### 2.3. Fund your accounts

Stellar accounts need to be funded wit at least 1 XLM  before existing. Stellar provide the friendbot utility that can fund test networks like futurenet. 

If you already have your `stellar/quickstart` docker container, because it's sharing its `8000` port, you can call the Friendbot by doing

```bash
TOKEN_ADMIN_ADDRESS="GCUA5RTRR4N4ILSMORG3XFXJZB6KRG4QB22Z45BUNO5LIBCOYYPZ6TPZ"
FRIENDBOT_URL="http://localhost:8000/soroban/rpc/friendbot"
curl --silent -X POST "FRIENDBOT_URL?addr=TOKEN_ADMIN_ADDRESS" >/dev/null
```
If you want to call this from the `soroban-preview-7` docker container, be sure to change `http://localhost:8000` to `http://stellar:8000` because the  two docker container are using the same docker network and can be called by their name.  You can also use `https://friendbot-futurenet.stellar.org/` in case your request  is to the futurenet directly.  

### 2.4. Use our code

If you want to use our [Token Playground's Repo](https://github.com/esteblock/token-playground/) **code**, we prepared the [src/friendbot.js](https://github.com/esteblock/token-playground/blob/main/src/friendbot.js) script that can be called by the `soroban-preview-7` docker container:

```bash
docker exec soroban-preview-7 node src/friendbot.js
```

This script will take the issuer and receiver addresses from the [seetings.json](https://github.com/esteblock/token-playground/blob/main/settings.json) file:

```javascript
import fetch from 'node-fetch'
import settings from "../settings.json"  assert { type: "json" };

await fetch( settings.horizonUrl+'/friendbot?addr='+settings.issuerPublic, {method: 'POST'})
await fetch( settings.horizonUrl+'/friendbot?addr='+settings.receiverPublic, {method: 'POST'})
```

# 3. Next
In the [next chapter](4_issue_and_mint_asset_in_stellar.md) we will use this docker containers in order to issue and mint a new (classic) Stellar Asset

___

This Playgound has been developed by [@esteblock](https://github.com/esteblock/) in collaboration with [@marcos74](https://github.com/marcos74) from [@Dogstarcoin](https://github.com/Dogstarcoin)