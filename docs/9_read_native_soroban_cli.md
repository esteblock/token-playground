# Token Playground Chapter 9 : Read the native token (XLM) using soroban-cli


- Check this guide in [https://token-playground.gitbook.io/](https://token-playground.gitbook.io/)
- Edit this guide in it's repo: [https://github.com/esteblock/token-playground/](https://github.com/esteblock/token-playground/)
- Contribute to this guide in the [./docs folder](https://github.com/esteblock/token-playground/tree/main/docs) of the repo

## 1. Introduction
What about when we want to use XLM inside a Soroban smart contract? How do we trigger those transactions? Can we trigger transactions on behalf the user using the `require_auth` method?
 
In this chapter we will use our XLM inside Soroban using soroban-cli!

## 2. The native Stellar Lumens (XLM) contract address
Soroban is great! And in order to use the native XLM tokens, we just need to treat it as another asset that behaves as an Stellar Asset Contract (SAC). It indeed has it's own contract address.

We will call this **the native token address**

This contract address is unique per network (standalone, futurenet... as well as it will later be with testnet and mainnet), so be sure to call it correctly.

1. Wrap the native token:
In order to get the XLM "contract address" you first need to "wrap" the native asset it into a token inside Soroban. This can be done only once, but you'll be needing to do it each time you open a new Standalone instance. 

If you use only Futurenet, you'll probably never need to do this:

```bash
TOKEN_ADDRESS=$(soroban lab token wrap $ARGS --asset native)
echo Wrapped with address result: $TOKEN_ADDRESS
```
This command will return the address, so no need for the next step. If this commands fails, this means that the token has already been wrapped before :)

2. Get the native token's contracts address:
Once the native token has been wrapped, you can also it's address like this:

```bash
soroban lab token id --asset native --network standalone
```
and you'll get 
```bash
CDMLFMKMMD7MWZP3FKUBZPVHTUEDLSX4BYGYKH4GCESXYHS3IHQ4EIG4
```

and for the case of futurenet you'll get:
```bash
soroban lab token id --asset native --network futurenet

CB64D3G7SM2RTH6JSGG34DDTFTQ5CFDKVDZJZSODMCX4NJ2HV2KN7OHT
```

## 3. Native token and Token Interface
So, can we use this address as if it was any other token that complies with the [token interface](https://soroban.stellar.org/docs/reference/interfaces/token-interface)?

Yes! So let's do it.

Implementing the **token intrface** means that the contract will have the following functions: (please take a look at the link above)

```rust
pub trait Contract {
    // --------------------------------------------------------------------------------
    // Admin interface – privileged functions.
    // --------------------------------------------------------------------------------
    //
    // All the admin functions have to be authorized by the admin with all input
    // arguments, i.e. they have to call `admin.require_auth()`.

    /// Clawback "amount" from "from" account. "amount" is burned.
    /// Emit event with topics = ["clawback", admin: Address, to: Address], data = [amount: i128]
    fn clawback(
        env: soroban_sdk::Env,
        from: Address,
        amount: i128,
    );

    /// Mints "amount" to "to".
    /// Emit event with topics = ["mint", admin: Address, to: Address], data = [amount: i128]
    fn mint(
        env: soroban_sdk::Env,
        to: Address,
        amount: i128,
    );

    /// Sets the administrator to the specified address "new_admin".
    /// Emit event with topics = ["set_admin", admin: Address], data = [new_admin: Address]
    fn set_admin(
        env: soroban_sdk::Env,
        new_admin: Address,
    );

    /// Sets whether the account is authorized to use its balance.
    /// If "authorized" is true, "id" should be able to use its balance.
    /// Emit event with topics = ["set_authorized", id: Address], data = [authorize: bool]
    fn set_authorized(
        env: soroban_sdk::Env,
        id: Address,
        authorized: bool,
    );

    // --------------------------------------------------------------------------------
    // Token interface
    // --------------------------------------------------------------------------------
    //
    // All the functions here have to be authorized by the token spender
    // (usually named `from` here) using all the input arguments, i.e. they have
    // to call `from.require_auth()`.

    /// Set the allowance by "amount" for "spender" to transfer/burn from "from".
    /// "expiration_ledger" is the ledger number where this allowance expires. It cannot
    /// be less than the current ledger number unless the amount is being set to 0.
    /// An expired entry (where "expiration_ledger" < the current ledger number)
    /// should be treated as a 0 amount allowance.
    /// Emit event with topics = ["approve", from: Address, spender: Address], data = [amount: i128, expiration_ledger: u32]
    fn approve(
        env: soroban_sdk::Env,
        from: Address,
        spender: Address,
        amount: i128,
        expiration_ledger: u32,
    );

    /// Transfer "amount" from "from" to "to".
    /// Emit event with topics = ["transfer", from: Address, to: Address], data = [amount: i128]
    fn transfer(
        env: soroban_sdk::Env,
        from: Address,
        to: Address,
        amount: i128,
    );

    /// Transfer "amount" from "from" to "to", consuming the allowance of "spender".
    /// Authorized by spender (`spender.require_auth()`).
    /// Emit event with topics = ["transfer", from: Address, to: Address], data = [amount: i128]
    fn transfer_from(
        env: soroban_sdk::Env,
        spender: Address,
        from: Address,
        to: Address,
        amount: i128,
    );

    /// Burn "amount" from "from".
    /// Emit event with topics = ["burn", from: Address], data = [amount: i128]
    fn burn(
        env: soroban_sdk::Env,
        from: Address,
        amount: i128,
    );

    /// Burn "amount" from "from", consuming the allowance of "spender".
    /// Emit event with topics = ["burn", from: Address], data = [amount: i128]
    fn burn_from(
        env: soroban_sdk::Env,
        spender: Address,
        from: Address,
        amount: i128,
    );

    // --------------------------------------------------------------------------------
    // Read-only Token interface
    // --------------------------------------------------------------------------------
    //
    // The functions here don't need any authorization and don't emit any
    // events.

    /// Get the balance of "id".
    fn balance(env: soroban_sdk::Env, id: Address) -> i128;

    /// Get the spendable balance of "id". This will return the same value as balance()
    /// unless this is called on the Stellar Asset Contract, in which case this can
    /// be less due to reserves/liabilities.
    fn spendable_balance(env: soroban_sdk::Env id: Address) -> i128;

    // Returns true if "id" is authorized to use its balance.
    fn authorized(env: soroban_sdk::Env, id: Address) -> bool;

    /// Get the allowance for "spender" to transfer from "from".
    fn allowance(
        env: soroban_sdk::Env,
        from: Address,
        spender: Address,
    ) -> i128;

    // --------------------------------------------------------------------------------
    // Descriptive Interface
    // --------------------------------------------------------------------------------

    // Get the number of decimals used to represent amounts of this token.
    fn decimals(env: soroban_sdk::Env) -> u32;

    // Get the name for this token.
    fn name(env: soroban_sdk::Env) -> soroban_sdk::Bytes;

    // Get the symbol for this token.
    fn symbol(env: soroban_sdk::Env) -> soroban_sdk::Bytes;
}
```


In order to call a function of the native asset smart contract inside **soroban-cli**, we need to provide the WASM. This will tell **soroban-cli** what are the name of the functions, name and number of variables and what does the function returns. 

This is why that in order to interact with the native contract address, we need first a WASM of a token that implements the token interface.


## 4. Get the WASM of a token contract.

Now we will use the stellar token's contract address found in section 2, together with the token WASM after compiling the a token contract that implements the token interface.

In this case we'll use the token contract available in `https://github.com/stellar/soroban-examples/`

1. Get the token contract.
Clone `https://github.com/stellar/soroban-examples/` and compile the token contract.
In this repository you'll find already the token contract of the release [0.9.2](https://github.com/stellar/soroban-examples/releases/tag/v0.9.2) (complying with preview 10) 
```bash
cd src/contracts/token
```

2. Compile the token
```bash
make build
```
This will create the compiled wasm in `/workspace/src/contracts/token/target/wasm32-unknown-unknown/release/soroban_token_contract.wasm`


## 5. Check your balance using  soroban-cli and the native token's contract address.
We have the native token's address and the WASM of a token contract that implements the token interface. We just need to call it!

0.- Set your environment. 
Here we suppose that you are using the `soroban-preview:10` image as it was explained in previous chapters:

```bash
TOKEN_WASM="/workspace/src/contracts/token/target/wasm32-unknown-unknown/release/soroban_token_contract.wasm"

TOKEN_ADDRESS="$(soroban lab token id --asset native --network standalone)"

NETWORK="standalone"
SOROBAN_RPC_HOST="http://stellar:8000"
SOROBAN_RPC_URL="$SOROBAN_RPC_HOST/soroban/rpc"
FRIENDBOT_URL="$SOROBAN_RPC_HOST/friendbot"
SOROBAN_NETWORK_PASSPHRASE="Standalone Network ; February 2017"
soroban config network add "$NETWORK" \
  --rpc-url "$SOROBAN_RPC_URL" \
  --network-passphrase "$SOROBAN_NETWORK_PASSPHRASE"
ARGS="--network standalone --source-account my-account"
```

1.- Create a soroban-cli identity
```bash
soroban config identity generate my-account
MY_ACCOUNT_ADDRESS="$(soroban config identity address my-account)"
```

2.- Fund this identity with the friendbot
```bash
curl  -X POST "$FRIENDBOT_URL?addr=$MY_ACCOUNT_ADDRESS"
```

3.- Ask your balance to the native token's contract:
```bash
MY_BALANCE=$(soroban contract invoke \
  $ARGS \
  --wasm $TOKEN_WASM \
  --id "$TOKEN_ADDRESS" \
  -- \
  balance \
  --id $MY_ACCOUNT_ADDRESS)
echo my-account XLM balance: $MY_BALANCE
```

You should have an answer like this one:
```bash
Asking the native tokens contract what is my-account balance:
my-account XLM balance: "99999952867"
```

## 6. Asking other things:
```bash
soroban contract invoke \
  $ARGS \
  --wasm $TOKEN_WASM \
  --id "$TOKEN_ADDRESS" \
  -- \
  name
```

```
"native"
```

## 7. Use our code

If you want to use our **code** in the [Token Playground's Repo](https://github.com/esteblock/token-playground/), you can just call our script with the `soroban-preview-10` docker containter

You can run it by: 

```bash
bash src/chapter9/native_XLM_soroban_read.sh 
```

Check all the code in the repo!


# What is next?
In this chapter we wrapped the native token, read it's address, generated a token WASM and interacted with these using soroban-cli in order to read some information about the native asset (balance, name)!

In the next chapter we'll use this contract address in order to send some XLM!

Are you ready?

___

This Playground chapter has been written by [@esteblock](https://github.com/esteblock/)



