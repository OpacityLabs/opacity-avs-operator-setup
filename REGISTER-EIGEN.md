# Register Node Operator with EigenLayer mainnet

The following is not Opacity specific but for EigenLayer. We will be summarizing the following verboase guide: [EigenLayer Guide](https://docs.eigenlayer.xyz/eigenlayer/operator-guides/operator-installation)

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

## Fund Operator Wallet with ETH

Make sure your operator wallet has enough ETH to be able to make the transactions to register.

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
el_delegation_manager_address: 0x39053D51B77DC0d36036Fc1fCc8Cb819df8Ef37A
eth_rpc_url: https://holesky.infura.io/v3/...
#! Make sure this path is correct
private_key_store_path: <path to your private key>
signer_type: local_keystore
chain_id: 1
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


## Make sure you have 20ETH of Supported LSTs Delegated to your Operator

- [Beacon Ether](https://app.eigenlayer.xyz/restake/ETH)
- [stETH](https://app.eigenlayer.xyz/restake/stETH)
- [rETH](https://app.eigenlayer.xyz/restake/rETH)
- [cbETH](https://app.eigenlayer.xyz/restake/cbETH)
- [ETHx](https://app.eigenlayer.xyz/restake/ETHx)
- [ankrETH](https://app.eigenlayer.xyz/restake/ankrETH)
- [OETH](https://app.eigenlayer.xyz/restake/OETH)
- [osETH](https://app.eigenlayer.xyz/restake/osETH)
- [swETH](https://app.eigenlayer.xyz/restake/swETH)
- [wBETH](https://app.eigenlayer.xyz/restake/wBETH)
- [sfrxETH](https://app.eigenlayer.xyz/restake/sfrxETH)
- [lsETH](https://app.eigenlayer.xyz/restake/lsETH)
- [mETH](https://app.eigenlayer.xyz/restake/mETH)


Here is an example operator for our AVS on mainnet: [0xWildhare](https://app.eigenlayer.xyz/operator/0xe743b96d0c9b50a0d902a93c95ccb4ac8749a8c5)
