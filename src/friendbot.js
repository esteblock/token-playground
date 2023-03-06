import fetch from 'node-fetch'
import settings from "../settings.json"  assert { type: "json" };

await fetch( settings.horizonUrl+'/friendbot?addr='+settings.issuerPublic, {method: 'POST'})
await fetch( settings.horizonUrl+'/friendbot?addr='+settings.receiverPublic, {method: 'POST'})