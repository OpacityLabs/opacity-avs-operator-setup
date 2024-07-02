# Register Node Operator with EigenLayer local fork

The following is not Opacity specific but for EigenLayer. We will be summarizing the following verboase guide: [EigenLayer Guide](https://docs.eigenlayer.xyz/eigenlayer/operator-guides/operator-installation)

## USE THE FORK RPC THROUGH OUT



## Create ECDSA and BLS keys

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

## Fund ECDSA Wallet with testnet ETH

We need to load your operator wallet with some holesky eth to submit transactions. See: [EigenLayer testnet LST Guide](https://docs.eigenlayer.xyz/eigenlayer/restaking-guides/restaking-user-guide/testnet/obtaining-testnet-eth-and-liquid-staking-tokens-lsts)

Google cloud gives a good amount: [Google cloud faucet](https://cloud.google.com/application/web3/faucet/ethereum/holesky). But you

## Use some Holesky eth to get holesky stETH: [LIDO staking app](https://stake-holesky.testnet.fi/)

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
Enter your ETH rpc url: https://ethereum-holesky.publicnode.com
Select your network: holesky
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
