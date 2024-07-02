# Register Node Operator with EigenLayer local fork

The following is not Opacity specific but for EigenLayer. We will be summarizing the following verbose guide: [EigenLayer Guide](https://docs.eigenlayer.xyz/eigenlayer/operator-guides/operator-installation)

## USE THE FORK RPC THROUGH OUT

clone the avs contract repo

```bash
git clone https://github.com/OpacityLabs/opacity-avs-contracts.git && cd opacity-avs-contracts
```

create .env with mainnet RPC info and start fork

```bash
anvil --fork-url mainnet
```

in a second window, deploy Opacity AVS contracts (using one of the anvil signers as the private key)

```bash
forge build && forge script script/Deploy.s.sol:Deploy --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
```

NOTE: Check that the contract values match between this repo (opacity-avs-operator-setup/config/fork/opacity.config.yaml,) and the contracts repo (opacity-avs-contracts/script/output/1/opacity_avs_deployment_output.json)

- registry_coordinator_address == RegistryCoordinatorProxy
- opacity_vs_address == OpacityServiceManagerProxy

## Create ECDSA and BLS keys

Continue in a cli for this repo...

```bash
make generate-operator-keys
```

OR

```bash
./bin/eigenlayer operator keys create --key-type ecdsa opacity
./bin/eigenlayer operator keys create --key-type bls opacity
```

To check if you did it right you can run:

```bash
make list-keys
```

OR

```bash
./bin/eigenlayer operator keys list
```

<img width="1487" alt="Screenshot 2024-06-20 at 1 40 44 PM" src="https://github.com/OpacityLabs/opacity-avs-operator-setup/blob/main/assets/list-keys.png?raw=true">

---

## Fund ECDSA Wallet with forked ETH and RETH and deposit into Staking Strategy

send eth to your operator (we are sending from the same anvil pk we used above 0xac0...f80)

```bash
cast send –private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 <your ECDSA Ethereum Address> --value 1ether
```

Get RETH (we are using cheat codes to steal it from a large account)

```bash
export OPER=<your operator ECDSA address>
export RETH=0xae78736Cd615f374D3085123A210448E74Fc6393
export WHALE=0x3ad1b118813e71a6b2683FCb2044122fe195AC36
```

```bash
cast rpc anvil_impersonateAccount $WHALE
cast send $RETH --from $WHALE "transfer(address,uint256)(bool)" $OPER 20000000000000000000 --unlocked
```

approve StrategyManager to spend your RETH:

```bash
export STRAT=0x1BeE69b7dFFfA4E2d53C2a2Df135C388AD25dCD2
export STRAT_MANAGER=0x858646372CC42E1A627fcE94aa7A7033e7CF075A
```

```bash
cast rpc anvil_impersonateAccount $OPER
cast send $RETH --from $OPER "approve(address,uint256)(bool)" $STRAT_MANAGER 20000000000000000000 --unlocked
```

deposit into strategy

```bash
cast rpc anvil_impersonateAccount $OPER
cast send $STRAT_MANAGER --from $OPER "depositIntoStrategy(address,address,uint256)(uint256)" $STRAT $RETH 20000000000000000000 --unlocked
```

## Create Operator config

We need to generate some metadata so eigenlayer can show you nicely in their UI.

I would recommend forking this repo: [operator metadata](https://github.com/Hmac512/eigenpod) and changing the values to your liking, be sure to replace the image with your own!

Run:

```bash
make create-operator-config
```

OR

```bash
./bin/eigenlayer operator config create
```

Say yes to populating the config

```bash
Enter your operator address: 0xfe8463ca0a9b436fdc5f75709ad5a43961802d68
Enter your earnings address (default to your operator address): 0xfe8463ca0a9b436fdc5f75709ad5a43961802d68
Enter your ETH rpc url: http://localhost:8545
Select your network: mainnet
Select your signer type: local_keystore
Enter your ecdsa key path: /home/ubuntu/.eigenlayer/operator_keys/opacity.ecdsa.key.json
```

This will generate a operator.yaml file that should look like:

```yaml
operator:
  address: <your operator address>
  earnings_receiver_address: <your operator address>
  delegation_approver_address: "0x0000000000000000000000000000000000000000"
  staker_opt_out_window_blocks: 0
  #! Update this to be correct
  metadata_url: "https://raw.githubusercontent.com/<github-username>/eigenpod/main/metadata.json"
el_delegation_manager_address: 0xA44151489861Fe9e3055d95adC98FbD462B948e7
eth_rpc_url: https://ethereum-holesky.publicnode.com
#! Make sure this path is correct
private_key_store_path: <path to your private key>
signer_type: local_keystore
chain_id: 17000
fireblocks:
  api_key: ""
  secret_key: ""
  base_url: ""
  vault_account_name: ""
  secret_storage_type: ""
  aws_region: ""
  timeout: 0
web3:
  url: ""
```

Remember to fill out the metadata_url to your forked repo, and that private_key_store_path is correct! If you don't get the metadata right the first time, sometimes it takes a few min for the cache to refresh.

<b><u>Make a backup of your operator.yaml for convenience</u></b>

## Register Node Operator

RUN:

```bash
make register-eigen-operator
```

OR:

```bash
./bin/eigenlayer operator register operator.yaml
```

You should see:

<img width="1572" alt="Screenshot 2024-06-20 at 1 35 59 PM" src="https://github.com/OpacityLabs/opacity-avs-operator-setup/blob/main/assets/register-eigen.png?raw=true">
