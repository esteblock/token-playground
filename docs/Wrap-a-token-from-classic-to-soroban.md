# Token Playground Chapter 6:   Wrap a token from Classic to Soroban.

To interact with a stellar asset from Soroban you will need to wrap the asset. You can  wrap the asset by running the next docker command

```
docker exec soroban-preview-7 ./src/wrap.sh standalone using_docker
```

If script runs succesfully the contract id (token id) will be stored in the folder .soroban/token_id

The contract id will required  to interact later with the contract via soroban. 

The script internally calls the lab wrap feature from soroban cli.

Next you'll find a sample:

```
soroban lab token wrap --asset="AstroDollar:GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI" --secret-key SAHC723FQTC3MARBNUZLUFEIYI62VQDQH7FHLD2FGV6GROQQ7ULMHQGH --rpc-url https://horizon-futurenet.stellar.cash:443/soroban/rpc --network-passphrase 'Test SDF Future Network ; October 2022'
success
86b9acd9860d105c2b5e6b688ab0fce5f9c45516dcc704f9427936c79384e72f
```

The last line in the previous sample corrspond to the contract id, a 32-byte byte arrays, represented by BytesN<32> 



