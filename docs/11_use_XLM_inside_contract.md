# Token Playground Chapter 10 : Write the native token (XLM) contract using soroban-cli


- Check this guide in [https://token-playground.gitbook.io/](https://token-playground.gitbook.io/)
- Edit this guide in it's repo: [https://github.com/esteblock/token-playground/](https://github.com/esteblock/token-playground/)
- Contribute to this guide in the [./docs folder](https://github.com/esteblock/token-playground/tree/main/docs) of the repo

## 1. Introduction
What about when we want to use XLM inside a Soroban smart contract? How do we trigger those transactions? Can we trigger transactions on behalf the user using the `require_auth` method?
 
In this chapter we will write a smart contract that will interact with our XML balance!

## 2. A donations contract
In order to interact with our XML balance inside a Soroban smart contract, let's write a "donations" contract where any donor can send XML to the contract, and a "recipient" can then withdraw all the funds:

**Check the code:** All the code used in this chapter is available in https://github.com/esteblock/donations-dapp-soroban

Our contract will have this functions:

```rust

// Contract Trait
pub trait DonationsTrait {
    // Sets the recepient address and the token that will be accepted as donation
    fn initialize(e: Env, recipient: Address, token: Address);

    // Donates amount units of the accepted token
    fn donate(e: Env, donor: Address, amount: i128);

    // Transfer all the accumulated donations to the recipient. Can be called by anyone
    fn withdraw(e: Env);

    // Get the token address that is accepted as donations
    fn token(e:Env) -> Address;

    // Get the donations recipient address
    fn recipient(e:Env) -> Address;
}
```

The full code will be:
```rust
#![no_std]
use soroban_sdk::{
    contract, contractimpl, Env, Address, Val, TryFromVal, ConversionError, token
};
mod test;

#[derive(Clone, Copy)]
// Data Keys
pub enum DataKey {
    AcceptedToken = 0,        // address of the accepted token
    DonationsRecipient =1,       // address of the donations recipient
}

impl TryFromVal<Env, DataKey> for Val {
    type Error = ConversionError;

    fn try_from_val(_env: &Env, v: &DataKey) -> Result<Self, Self::Error> {
        Ok((*v as u32).into())
    }
}

// Helper functions
fn put_token_address(e: &Env, token: &Address) {
    e.storage().instance().set(&DataKey::AcceptedToken, token);
}

fn put_donations_recipient(e: &Env, recipient: &Address) {
    e.storage().instance().set(&DataKey::DonationsRecipient, recipient);
}

fn get_token_address(e: &Env) -> Address {
    e.storage()
        .instance()
        .get(&DataKey::AcceptedToken)
        .expect("not initialized")
}

fn get_donations_recipient(e: &Env) -> Address {
    e.storage()
        .instance()
        .get(&DataKey::DonationsRecipient)
        .expect("not initialized")
}

fn get_balance(e: &Env, token_address: &Address) -> i128 {
    let client = token::Client::new(e, token_address);
    client.balance(&e.current_contract_address())
}

// Transfer tokens from the contract to the recipient
fn transfer(e: &Env, to: &Address, amount: &i128) {
    let token_contract_address= &get_token_address(e);
    let client = token::Client::new(e, token_contract_address);
    client.transfer(&e.current_contract_address(), to, amount);
}


// Contract Trait
pub trait DonationsTrait {
    // Sets the recepient address and the token that will be accepted as donation
    fn initialize(e: Env, recipient: Address, token: Address);

    // Donates amount units of the accepted token
    fn donate(e: Env, donor: Address, amount: i128);

    // Transfer all the accumulated donations to the recipient. Can be called by anyone
    fn withdraw(e: Env);

    // Get the token address that is accepted as donations
    fn token(e:Env) -> Address;

    // Get the donations recipient address
    fn recipient(e:Env) -> Address;
}

#[contract]
struct Donations;

// Contract implementation
#[contractimpl]
impl DonationsTrait for Donations {

    // Sets the recepient address and the token that will be accepted as donation
    fn initialize(e: Env, recipient: Address, token: Address){
        assert!(
            !e.storage().instance().has(&DataKey::AcceptedToken),
            "already initialized"
        );
        put_token_address(&e, &token);
        put_donations_recipient(&e, &recipient);
    }

    // Donor donates amount units of the accepted token
    fn donate(e: Env, donor: Address, amount: i128){
        donor.require_auth();
        //assert!(amount > 0, "amount must be positive");
        let token_address = get_token_address(&e);
        let client = token::Client::new(&e, &token_address); 
        // Transfer from user to this contract
        client.transfer(&donor, &e.current_contract_address(), &amount);
    }

    // Transfer all the accumulated donations to the recipient. Can be called by anyone
    fn withdraw(e: Env){
        let token = get_token_address(&e);
        let recipient = get_donations_recipient(&e);
        transfer(&e, &recipient, &get_balance(&e, &token));
    }

    // Get the token address that is accepted as donations
    fn token(e:Env) -> Address{
        get_token_address(&e)
    }

    // Get the donations recipient address
    fn recipient(e:Env) -> Address{
        get_donations_recipient(&e)
    }

}

```

## 2. Testing the contract with rs-soroban-sdk
The first thing we allways do when we write an smart contract is to test it inside a `test.rs` file and we test it with `make test`. This will test the contract in a Soroban environment provided by `rs-soroban-sdk`. (the rust soroban-sdk)

How can we tell the contract that we want to use the native XML?
Well.... I an not pretty sure... and this is why I am opening this discussion on Discord: https://discord.com/channels/897514728459468821/1145462925109231726/1145462925109231726


In the `test.rs` file you'll find 2 tests. One is for any type of tokens, and works perfect. The second test is ment to be only for the native XML token....

When you create the XML native token inside `test.rs` you get:
```rust
fn native_asset_contract_address(e: &Env) -> Address {
    let native_asset = Asset::Native;
    let contract_id_preimage = ContractIdPreimage::Asset(native_asset);
    let bytes = Bytes::from_slice(&e, &contract_id_preimage.to_xdr().unwrap());
    let native_asset_address = Address::from_contract_id(&e.crypto().sha256(&bytes));
    native_asset_address
}

 // Set the native token address
    let native_address =native_asset_contract_address(&e);    
    let expected_address_string = "CDF3YSDVBXV3QU2QSOZ55L4IVR7UZ74HIJKXNJMN4K5MOVFM3NDBNMLY";
    let Strkey::Contract(array) = Strkey::from_string(expected_address_string).unwrap() else { panic!("Failed to convert address") };
    let contract_id = BytesN::from_array(&e, &array.0);
    let expected_asset_address = Address::from_contract_id(&contract_id);
    assert_eq!(native_address, expected_asset_address);

```

Until there everything is OK, but if you'll later want to check any user's balance.... how van we do it inside `test.rs`? I get these errors:

```rust
---- test::test stdout ----
thread 'test::test' panicked at 'HostError: Error(Storage, MissingValue)

Event log (newest first):
   0: [Diagnostic Event] topics:[error, Error(Storage, MissingValue)], data:"escalating error to panic"
   1: [Diagnostic Event] topics:[error, Error(Storage, MissingValue)], data:["contract call failed", name, []]
   2: [Diagnostic Event] topics:[fn_call, Bytes(cbbc48750debb8535093b3deaf88ac7f4cff87425576a58de2bac754acdb4616), name], data:Void
   3: [Diagnostic Event] contract:83b030d83a5d502cc001c50f8b714ce54a0ba8c6c4cda46281a060cd47134695, topics:[fn_return, token], data:Address(Contract(cbbc48750debb8535093b3deaf88ac7f4cff87425576a58de2bac754acdb4616))
   4: [Diagnostic Event] topics:[fn_call, Bytes(83b030d83a5d502cc001c50f8b714ce54a0ba8c6c4cda46281a060cd47134695), token], data:Void
   5: [Diagnostic Event] contract:83b030d83a5d502cc001c50f8b714ce54a0ba8c6c4cda46281a060cd47134695, topics:[fn_return, recipient], data:Address(Contract(06ecc85c9d15d14b787b5eafe1afa00e78f9fbd8fb8003b9bbe1735efe00f911))
   6: [Diagnostic Event] topics:[fn_call, Bytes(83b030d83a5d502cc001c50f8b714ce54a0ba8c6c4cda46281a060cd47134695), recipient], data:Void
   7: [Diagnostic Event] contract:83b030d83a5d502cc001c50f8b714ce54a0ba8c6c4cda46281a060cd47134695, topics:[fn_return, initialize], data:Void
   8: [Diagnostic Event] topics:[fn_call, Bytes(83b030d83a5d502cc001c50f8b714ce54a0ba8c6c4cda46281a060cd47134695), initialize], data:[Address(Contract(06ecc85c9d15d14b787b5eafe1afa00e78f9fbd8fb8003b9bbe1735efe00f911)), Address(Contract(cbbc48750debb8535093b3deaf88ac7f4cff87425576a58de2bac754acdb4616))]
```

## 3. Testing the contract inside a Quickstart Standalone blockchain and soroban-cli
Because tests in `soroban-sdk` did not work very well, we'll then deploy the contract in a real quickstart blockchain and we'll tell the contract that we'll use the nattive token address used in the previous chapers.

Check the code in: https://github.com/esteblock/donations-dapp-soroban/blob/main/test_soroban_cli.sh

Specifically we'll set:

```bash

echo Wrapping token
TOKEN_ADDRESS=$(soroban lab token wrap $ARGS --asset native)
echo Wrapped with address result: $TOKEN_ADDRESS
echo ---

echo Wrapping might fail if it was done before, so we are also getting the address:
TOKEN_ADDRESS="$(soroban lab token id --asset native --network standalone)"
echo Native token address: $TOKEN_ADDRESS
echo ---

```

and then:
```bash
echo Initialize the donations contract with native token address: $TOKEN_ADDRESS
soroban contract invoke $ARGS --wasm $WASM --id $DONATIONS_ID \
        -- initialize \
        --recipient $RECIPIENT \
        --token $TOKEN_ADDRESS
echo Contract initialized
echo ---
```

Also, when checking for accounts balances, in order to be sure, we'll check the balance both using the native token contract address and the classic way with node and the  js-soroban-sdk (the javascript soroban-sdk)

```javascript
var server = new StellarSdk.Server(horizonUrl, {allowHttp: true});

server.loadAccount(address)
  .then(account => {
    // Find the XLM balance
    const xlmBalance = account.balances.find(balance => balance.asset_type === 'native');

    console.log(`Address: ${address} | XLM balance: ${xlmBalance.balance}`);
  })
  .catch(error => {
    console.error('Error loading account:', error);
  });

```

If you wanna do the whole tests, just follow the instructions in the repo! You should get:

```bash
bash test_soroban_cli.sh 
```

The result should be:

```bash
Adding network
---
Wrapping token
Wrapped with address result: CDMLFMKMMD7MWZP3FKUBZPVHTUEDLSX4BYGYKH4GCESXYHS3IHQ4EIG4
---
Wrapping might fail if it was done before, so we are also getting the address:
Native token address: CDMLFMKMMD7MWZP3FKUBZPVHTUEDLSX4BYGYKH4GCESXYHS3IHQ4EIG4
---
Creating my-account identity
my-account was created: GAQCB6FOPJ3NW3CVJKJ5OZZ6FKISWPHYZ6B3IJALIBT62ZLM4Y42RFF4
---
Creating donor identity
donor was created: GCPGHSSVYJ4YJ4E2QPGK6UHYJEMKBKX6DDHWO544TUZN24HG6PHHYSN7
---
Creating recipient identity
recipient was created: GDPEITSHJP6OMTCVGHH5RO57P5MW6KYQEA5XBFBQSFSLQMF6RHREDETM
---
---
Deploy the donations contract:
cargo build --target wasm32-unknown-unknown --release 
    Finished release [optimized] target(s) in 0.16s
-rwxr-xr-x 2 root root 2148 Aug 28 11:32 target/wasm32-unknown-unknown/release/donations.wasm
Contract was deployed with address: CDG7FLYPFIKZA5PQQPOSAPUW67HJCYNNQFGJ3ULUYW2AV7IRUVRST3WF
---
Initialize the donations contract with native token address: CDMLFMKMMD7MWZP3FKUBZPVHTUEDLSX4BYGYKH4GCESXYHS3IHQ4EIG4

Contract initialized
---
Lets check the accepted token in contract
Expected: "CDMLFMKMMD7MWZP3FKUBZPVHTUEDLSX4BYGYKH4GCESXYHS3IHQ4EIG4"
Result: "CDMLFMKMMD7MWZP3FKUBZPVHTUEDLSX4BYGYKH4GCESXYHS3IHQ4EIG4"
Test passed
---
---
Lets check the recipient of the donations
Expected: "GDPEITSHJP6OMTCVGHH5RO57P5MW6KYQEA5XBFBQSFSLQMF6RHREDETM"
Result: "GDPEITSHJP6OMTCVGHH5RO57P5MW6KYQEA5XBFBQSFSLQMF6RHREDETM"
Test passed
---
---
Just as a workaround, the donor needs more XML in order to have the minimum XML to pay for the fees. Otherwise it wont be able to send
MY-ACCOUNT will send 1000000000 stroops to DONOR

Checking initial balance of donor
"101000000000"
Address: GCPGHSSVYJ4YJ4E2QPGK6UHYJEMKBKX6DDHWO544TUZN24HG6PHHYSN7 | XLM balance: 10100.0000000
---
Checking initial balance of recipient
"100000000000"
Address: GDPEITSHJP6OMTCVGHH5RO57P5MW6KYQEA5XBFBQSFSLQMF6RHREDETM | XLM balance: 10000.0000000
---
Checking initial balance of the donations contract
"0"
---
---
---
---
THE FIRST CALL TO THE CONTRACT WILL FAIL... WHY????
Donor donates 5 stroops to the contract
2023-08-28T11:50:39.327476Z ERROR soroban_cli::rpc: response=GetTransactionResponse { status: "FAILED", envelope_xdr: Some("AAAAAgAAAACeY8pVwnmE8JqDzK9Q+EkYoKr+GM9nd5ydMt1w5vPOfAAPQkAAAAMdAAAAAQAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAAAAAAQAAAASAAAAAc3yrw8qFZB18IPdID6W986RYa2BTJ3RdMW0Cv0RpWMpAAAADwAAAAZkb25hdGUAAAAAABIAAAAAAAAAAJ5jylXCeYTwmoPMr1D4SRigqv4Yz2d3nJ0y3XDm8858AAAACgAAAAAAAAAAAAAAAAAAAAUAAAABAAAAAAAAAAAAAAABzfKvDyoVkHXwg90gPpb3zpFhrYFMndF0xbQK/RGlYykAAAAGZG9uYXRlAAAAAAACAAAAEgAAAAAAAAAAnmPKVcJ5hPCag8yvUPhJGKCq/hjPZ3ecnTLdcObzznwAAAAKAAAAAAAAAAAAAAAAAAAABQAAAAEAAAAAAAAAAdiysUxg/stl+yqoHL6nnQg1yvwODYUfhhElfB5bQeHCAAAACHRyYW5zZmVyAAAAAwAAABIAAAAAAAAAAJ5jylXCeYTwmoPMr1D4SRigqv4Yz2d3nJ0y3XDm8858AAAAEgAAAAHN8q8PKhWQdfCD3SA+lvfOkWGtgUyd0XTFtAr9EaVjKQAAAAoAAAAAAAAAAAAAAAAAAAAFAAAAAAAAAAEAAAAAAAAAAwAAAAYAAAABzfKvDyoVkHXwg90gPpb3zpFhrYFMndF0xbQK/RGlYykAAAAUAAAAAQAAAAAAAAAGAAAAAdiysUxg/stl+yqoHL6nnQg1yvwODYUfhhElfB5bQeHCAAAAFAAAAAEAAAAAAAAAB+PjRjqK0s+gJdYgY0E9XGm55ULUipd1wxLu00oINUONAAAAAAAAAAIAAAAAAAAAAJ5jylXCeYTwmoPMr1D4SRigqv4Yz2d3nJ0y3XDm8858AAAABgAAAAHYsrFMYP7LZfsqqBy+p50INcr8Dg2FH4YRJXweW0HhwgAAABAAAAABAAAAAgAAAA8AAAAHQmFsYW5jZQAAAAASAAAAAc3yrw8qFZB18IPdID6W986RYa2BTJ3RdMW0Cv0RpWMpAAAAAQAAAAAAI9fhAAAMAAAAAeAAAAX4AAAAAAAAASsAAAAB5vPOfAAAAEBPNszaix41MQPzt4ceL6TeSE5coHLWGtJypGaum7YmvQ2NKjzSE9IGLiOsD5gzWxOYkIuKGqqlmyhp8sBWQY4C"), result_xdr: Some("AAAAAAABnML/////AAAAAQAAAAAAAAAY/////QAAAAA="), result_meta_xdr: Some("AAAAAwAAAAAAAAACAAAAAwAAAzUAAAAAAAAAAJ5jylXCeYTwmoPMr1D4SRigqv4Yz2d3nJ0y3XDm8858AAAAF4QQFT4AAAMdAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAQAAAzUAAAAAAAAAAJ5jylXCeYTwmoPMr1D4SRigqv4Yz2d3nJ0y3XDm8858AAAAF4QQFT4AAAMdAAAAAQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAAAADNQAAAABk7IoOAAAAAAAAAAAAAAACAAAAAwAAAzUAAAAAAAAAAJ5jylXCeYTwmoPMr1D4SRigqv4Yz2d3nJ0y3XDm8858AAAAF4QQFT4AAAMdAAAAAQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAAAADNQAAAABk7IoOAAAAAAAAAAEAAAM1AAAAAAAAAACeY8pVwnmE8JqDzK9Q+EkYoKr+GM9nd5ydMt1w5vPOfAAAABeEEBZpAAADHQAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAADAAAAAAAAAzUAAAAAZOyKDgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAA=") }
error: transaction submission failed: GetTransactionResponse {
    status: "FAILED",
    envelope_xdr: Some(
        "AAAAAgAAAACeY8pVwnmE8JqDzK9Q+EkYoKr+GM9nd5ydMt1w5vPOfAAPQkAAAAMdAAAAAQAAAAAAAAAAAAAAAQAAAAAAAAAYAAAAAAAAAAQAAAASAAAAAc3yrw8qFZB18IPdID6W986RYa2BTJ3RdMW0Cv0RpWMpAAAADwAAAAZkb25hdGUAAAAAABIAAAAAAAAAAJ5jylXCeYTwmoPMr1D4SRigqv4Yz2d3nJ0y3XDm8858AAAACgAAAAAAAAAAAAAAAAAAAAUAAAABAAAAAAAAAAAAAAABzfKvDyoVkHXwg90gPpb3zpFhrYFMndF0xbQK/RGlYykAAAAGZG9uYXRlAAAAAAACAAAAEgAAAAAAAAAAnmPKVcJ5hPCag8yvUPhJGKCq/hjPZ3ecnTLdcObzznwAAAAKAAAAAAAAAAAAAAAAAAAABQAAAAEAAAAAAAAAAdiysUxg/stl+yqoHL6nnQg1yvwODYUfhhElfB5bQeHCAAAACHRyYW5zZmVyAAAAAwAAABIAAAAAAAAAAJ5jylXCeYTwmoPMr1D4SRigqv4Yz2d3nJ0y3XDm8858AAAAEgAAAAHN8q8PKhWQdfCD3SA+lvfOkWGtgUyd0XTFtAr9EaVjKQAAAAoAAAAAAAAAAAAAAAAAAAAFAAAAAAAAAAEAAAAAAAAAAwAAAAYAAAABzfKvDyoVkHXwg90gPpb3zpFhrYFMndF0xbQK/RGlYykAAAAUAAAAAQAAAAAAAAAGAAAAAdiysUxg/stl+yqoHL6nnQg1yvwODYUfhhElfB5bQeHCAAAAFAAAAAEAAAAAAAAAB+PjRjqK0s+gJdYgY0E9XGm55ULUipd1wxLu00oINUONAAAAAAAAAAIAAAAAAAAAAJ5jylXCeYTwmoPMr1D4SRigqv4Yz2d3nJ0y3XDm8858AAAABgAAAAHYsrFMYP7LZfsqqBy+p50INcr8Dg2FH4YRJXweW0HhwgAAABAAAAABAAAAAgAAAA8AAAAHQmFsYW5jZQAAAAASAAAAAc3yrw8qFZB18IPdID6W986RYa2BTJ3RdMW0Cv0RpWMpAAAAAQAAAAAAI9fhAAAMAAAAAeAAAAX4AAAAAAAAASsAAAAB5vPOfAAAAEBPNszaix41MQPzt4ceL6TeSE5coHLWGtJypGaum7YmvQ2NKjzSE9IGLiOsD5gzWxOYkIuKGqqlmyhp8sBWQY4C",
    ),
    result_xdr: Some(
        "AAAAAAABnML/////AAAAAQAAAAAAAAAY/////QAAAAA=",
    ),
    result_meta_xdr: Some(
        "AAAAAwAAAAAAAAACAAAAAwAAAzUAAAAAAAAAAJ5jylXCeYTwmoPMr1D4SRigqv4Yz2d3nJ0y3XDm8858AAAAF4QQFT4AAAMdAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAQAAAzUAAAAAAAAAAJ5jylXCeYTwmoPMr1D4SRigqv4Yz2d3nJ0y3XDm8858AAAAF4QQFT4AAAMdAAAAAQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAAAADNQAAAABk7IoOAAAAAAAAAAAAAAACAAAAAwAAAzUAAAAAAAAAAJ5jylXCeYTwmoPMr1D4SRigqv4Yz2d3nJ0y3XDm8858AAAAF4QQFT4AAAMdAAAAAQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAMAAAAAAAADNQAAAABk7IoOAAAAAAAAAAEAAAM1AAAAAAAAAACeY8pVwnmE8JqDzK9Q+EkYoKr+GM9nd5ydMt1w5vPOfAAAABeEEBZpAAADHQAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAADAAAAAAAAAzUAAAAAZOyKDgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
    ),
}
---
---
---
---
Donor donates 5 stroops to the contract

Checking new balance of the donations contract ... should be 5 ...
"5"
---
Donor donates 7 stroops to the contract

Checking new balance of the donations contract ... should be 12 ...
"12"
---
Recipient withdraw the total balance inside the donations contract

Checking new balance of recipient ... should be 100000000012 ...
"100000000012"
Address: GDPEITSHJP6OMTCVGHH5RO57P5MW6KYQEA5XBFBQSFSLQMF6RHREDETM | XLM balance: 10000.0000012
---
Checking final balance of donations contract ... should be 0 ...
"0"
---

```


Why is the first donation failing? I don't know yet. Opened Discussion in Discord: https://discord.com/channels/897514728459468821/1145688416432963705/1145688416432963705

___

This Playground chapter has been written by [@esteblock](https://github.com/esteblock/)
