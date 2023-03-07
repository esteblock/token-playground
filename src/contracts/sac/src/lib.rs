#![no_std]
use soroban_sdk::{contractimpl, Address, BytesN, Env};

mod token {
    soroban_sdk::contractimport!(file = "../token/soroban_token_spec.wasm");
}

mod test;
mod testutils;

struct Sac;

#[contractimpl]
#[allow(clippy::needless_pass_by_value)]
impl Sac {
    pub fn transfer(e: Env, user: Address, amount: i128, dest: Address, asset: BytesN<32>) {
        user.require_auth();
        assert!(amount > 0, "amount must be positive");
        let client = token::Client::new(&e, &asset);
        client.xfer(&user, &dest, &amount);
    }
}
