# Token Playground Chapter 7 : Mint from a wrapped token in Soroban. 


- Check this guide in [https://token-playground.gitbook.io/](https://token-playground.gitbook.io/)
- Edit this guide in it's repo: [https://github.com/esteblock/token-playground/](https://github.com/esteblock/token-playground/)
- Contribute to this guide in the [./docs folder](https://github.com/esteblock/token-playground/tree/main/docs) of the repo

## 1. Introduction

In the previous chapters we have already:
- Issued a (classic) Stellar Assets in the (classic) Stellar blockchain.
- Wrapped this asset into a SAC (Stellar Asset Contract) token into Soroban

In this chapter we will **mint** some units of this **SAC** token inside the **Soroban** chain, so this token can be used by smart contracts!

## 2. Setting up your soroban-cli
Configure your soroban-cli to use the `token-admin` identity

```bash
soroban config identity address token-admin

```
Check last chapter if you don't know what this means.

## 3. Smart Contract ID
From last chapter, you'll need to have your **SAC**'s id, that can be something like this:
```
86b9acd9860d105c2b5e6b688ab0fce5f9c45516dcc704f9427936c79384e72f
```
If you followed our [Token Playground's code](https://github.com/esteblock/token-playground/), you should have this **id** inside the `.soroban/token_id` file

```
TOKEN_ID=$(cat .soroban/token_id)
```

## 3. Destination address
As when issuing an asset in Stellar Classic, in order to mint a token in Soroban, you need to send units of this token to some **receiver**, hence we will set a receiver address:
```
DESTINATION_ADDRESS=SBFJKSFA5YK2SUAVVSMEKDA44MYCBFSNNAORJSO7J437HJWU6G7SGAVF
```
If you are following our code, and you are using the `settings.json` file, you can do
```
DESTINATION_ADDRESS=$(cat ./settings.json | jq  -r '.receiverPublic' )
```

## 4. The xfer function
In order to mint, we will use the `soroban invoke` command in the `soroban-cli` in order to invoke a function inside the **SAC** contract.

The transfer function in a **SAC** contract is the **xfer** function and receives 3 arguments:
- `from`
- `to`
- `amount`

Here is a piece of code of the SAC contract

```rust
fn xfer(e: Env, from: Address, to: Address, amount: i128) {
        from.require_auth();

        check_nonnegative_amount(amount);
        spend_balance(&e, from.clone(), amount);
        receive_balance(&e, to.clone(), amount);
        event::transfer(&e, from, to, amount);
    } 
```

If you want to learn more about the **SAC** code in the [Stellar guide](https://soroban.stellar.org/docs/how-to-guides/stellar-asset-contract)

## 5. Invoke the xfer function and mint the token
If we invoke the xfer function from the issuer we will actually mint some units of the token, hence, we will do:

```
TOKEN_ADMIN_SECRET=$(cat ./settings.json | jq -r '.issuerSecret' )

NETWORK="standalone"

soroban contract invoke \
  --network $NETWORK --identity token-admin \
  --wasm src/contracts/token/soroban_token_spec.wasm \
  --id "$TOKEN_ID" \
  --fn xfer -- \
  --from "$TOKEN_ADMIN_ADDRESS" \
  --to "$DESTINATION_ADDRESS" \
  --amount "50000000" 
```

Here, `src/contracts/token/soroban_token_spec.wasm` is the path of token wasm file. We provide you the one used when wrapping the token.


## 6. Did it mint? in Stellar or in Classic?
How can we know if we in fact minted the token?

In fact, when we wrap the token, both balances of the token Soroban/Classic are shared. Hence, if we ask Stellar Classic it yould say that there are not 5 units anymore, but 10.

And if we ask to the SAC token, it should say the same.

In chapter 5 we took information about the Stellar Asset in the classic Stellar. Let's ask Stellar Classic (check chapter 5!)

```
docker exec soroban-preview-7 node src/getInfo.js
```

The answer:

```json
Futurenet Classic Info: 
{
  _links: { toml: { href: '' } },
  asset_type: 'credit_alphanum12',
  asset_code: 'MYASSETCODE',
  asset_issuer: 'GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI',
  paging_token: 'MYASSETCODE_GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI_credit_alphanum12',
  num_accounts: 1,
  num_claimable_balances: 0,
  num_liquidity_pools: 0,
  amount: '10.0000000',
  accounts: {
    authorized: 1,
    authorized_to_maintain_liabilities: 0,
    unauthorized: 0
  },
  claimable_balances_amount: '0.0000000',
  liquidity_pools_amount: '0.0000000',
  balances: {
    authorized: '10.0000000',
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

```

We have now 10 units of the token!
We managed to suscesfully mint a wrapped asset in Soroban!

## 5. Use our code

If you want to use our **code** in the [Token Playground's Repo](https://github.com/esteblock/token-playground/), you can just call our script with the `soroban-preview-7` docker containter

You can run it by: 

```bash
docker exec soroban-preview-7 ./src/mint_with_just_token_id.sh standalone using_docker
```

Check all the code of our `mint_with_just_token_id.sh` script [here](https://github.com/esteblock/token-playground/blob/main/src/mint_with_just_token_id.sh)


# What is next?
In this chapter we minted units in Soroban, but we checked the total balance in Classic. In the next chapter we will use the SAC contract to get information about the token in Soroban. We should get the same information than in classic. Why? Because balances are shared!

Are you ready?

___

This Playground has been developed by [@esteblock](https://github.com/esteblock/) in collaboration with [@marcos74](https://github.com/marcos74) from [@Dogstarcoin](https://github.com/Dogstarcoin)
