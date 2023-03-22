# Token Playground Chapter 3 : Environment preparation

To run Token playground script requires Docker installed in  your system. Next we detail the steps to follow in order to install envirenoment. Basically you will need: 

-  Create a  docker common network 
-  Run docker container soroban-preview, that includes soroban cli, Rust and other tools [Token Playground](https://github.com/esteblock/token-playground/) uses 
-  Run docker stellar/quickstart that provides a local  stellar node
-  Create two stellar address accounts (isser and destination address)
-  Configure setting.json    

Remember to **follow the code** in the [Token Playground's Repo](https://github.com/esteblock/token-playground/)


### 1.- Create a common docker network (only once) 

Create a common docker network will allow to the two docker containers that we will create in next steps communicate between each other.

You can create common network by: 

```
docker network create soroban-network
```

### 2.- Docker soroban-preview:

Docker linux image that contains Rust and soroban cli 0.6.0 in addition to a set of utilities to run [Token Playground](https://github.com/esteblock/token-playground/) scripts (curl, node, jq)

You can get docker image from [docker hub](https://hub.docker.com/u/esteblock) or build it by running [build.sh](https://github.com/esteblock/soroban-preview-docker/blob/main/preview_7/build.sh)  

Once you get the docker image you can run the docker command

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
           soroban-preview:7
```

or by using the script [quickstart.sh](https://github.com/esteblock/token-playground/blob/main/quickstart.sh) from the token playground repository.


### 3.- Docker stellar/quickstart

Stellar provides a docker image that contains stellar node including  stellar core programm and horizon server. You can initialize the node as standalone (transactions will not be synced to the network) or futurenet (transactions will be synced to futurenet network).

You can get and run stellar/quickstart by executing 

[quickstart.sh token playgroud](https://github.com/esteblock/token-playground/blob/main/quickstart.sh)

Running succesfully quickstart.sh will launch the two docker containers, local stellar node and  soroban preview.


### 4.- Create two addres accounts 

You will need two stellar accounts to use token playground. The first one will be the issuer address, responsible of creating and issuing Stellar Assets,  the second one will be the destination address that has to create a trustline to the asset and  recieve amounts after issuing and mint. 

You can use [stellar laboratory](https://laboratory.stellar.org/#account-creator?network=futurenet) to create the accounts.  Stellar account need to be funded with at least 1 xlm  before exists. Stellar provide the utlity friendbot that fund test networks like futurenet. 

Here is an example about how to fund and make account exist:

```
TOKEN_ADMIN_ADDRESS="GCUA5RTRR4N4ILSMORG3XFXJZB6KRG4QB22Z45BUNO5LIBCOYYPZ6TPZ"
FRIENDBOT_URL="http://stellar:8000/soroban/rpc/friendbot"

curl --silent -X POST "FRIENDBOT_URL?addr=TOKEN_ADMIN_ADDRESS" >/dev/null

```

Note that this sample code requires  docker exec soroban-preview-7  to execute it and to have  followed previous steps. Sample code above uses ```http://stellar:8000``` as friendbot url  because the  two docker container are sharing the network.  In case you have not created docker common network use  ```http://localhost:8000``` if your friendbot  request is to  stellar/quickstart or ```https://friendbot-futurenet.stellar.org/```  in case your request  is to futurenet directly.  


if you want to use our **code** in the [Token Playground's Repo](https://github.com/esteblock/token-playground/), you can just call our script with the `soroban-preview-7` docker container-

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