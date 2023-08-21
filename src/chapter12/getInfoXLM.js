import StellarSdk from "stellar-sdk";
import settings from "/workspace/settings.json"  assert { type: "json" };

const args = process.argv;
const user_address = args[2]

var server = new StellarSdk.Server(settings.horizonUrl, {allowHttp: true});

server.loadAccount(user_address)
  .then(account => {
    // Find the XLM balance
    const xlmBalance = account.balances.find(balance => balance.asset_type === 'native');

    console.log(`Your XLM balance: ${xlmBalance.balance}`);
  })
  .catch(error => {
    console.error('Error loading account:', error);
  });
