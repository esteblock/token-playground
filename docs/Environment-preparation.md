# Token Playground Chapter 3 : Environment preparation


To run Token playground script requires Docker isntalled in  your system . Next we detail the steps to follow in order to isntall envirenoment. Basically you willl need: 


-  Create a  docker common network 
-  Run docker container soroban-preview, that includes soroban cli, rus 
-  Create two stellar address accounts (isser and destination address)
-  Configure setting.json    


### 1.- Create a common docker network (only once) 

```
docker network create soroban-network
```

### 2.- Docker soroban-preview:

Docker linux image that contains rust and soroban cli 0.6.0 in addition to a set of utilities to run scripts (curl, node, jq)

You can get docker image from [docker hub](https://hub.docker.com/u/esteblock) or build by running [build.sh](https://github.com/esteblock/soroban-preview-docker/blob/main/preview_7/build.sh)  

Once you get the docker image you can run the docker command


```docker run --rm -ti \
  --platform linux/amd64 \
  --name stellar \
  --network soroban-network \
  -p 8000:8000 \
  stellar/quickstart:soroban-dev@sha256:81c23da078c90d0ba220f8fc93414d0ea44608adc616988930529c58df278739 \
  standalone \
  --enable-soroban-rpc \
  --protocol-version 20 
```

or the script [quickstart.sh](https://github.com/esteblock/token-playground/blob/main/quickstart.sh) from the token playground repository.



### 3.- Docker stellar/quickstart


Stellar provides a docker image that contains stellar node including  stellar core programm and horizon server. You can initialize the node as standalone (transactions will not be synced to the network) and futurenet (transactions will be synced to futurenet network).


You can get and run stellar/quickstart by executing 

[quickstart.sh token playgroud](https://github.com/esteblock/token-playground/blob/main/quickstart.sh)

 Running succesfully  quickstar.sh wil launch the two docker containers, stellar node and    soroban preview


### 4.- Create two addres accounts 

You will need two stellar accounts to use token playground. The first one will be the issuer address, responsible of creating and issuing Stellar Assets,  the second one wiil be the destination address that has to create a trustline to the asset and  recieve amounts after issuing and mint. 

You can use [stellar laboratory](https://laboratory.stellar.org/#account-creator?network=futurenet) to create the accounts.  Stellar account need to be funded wit at least 1 xlm  before  existe. Stellar provide the utlity friendbot that fund test networks like futurenet. 

To fund and make account exist you can run:

```
docker exec soroban-preview-7 node src/friendbot.js
```

You will need to set up the two address in [seetings.json](https://github.com/esteblock/token-playground/blob/main/settings.json) to get the friendbot script run successfully. 



### 5.- Configure settings.js

The file settings.json include a set of variables required to run the different scripts of the token playground. Here you have a sample: 

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
    "limit": "1000"  //limit ammount  receive
}
```






