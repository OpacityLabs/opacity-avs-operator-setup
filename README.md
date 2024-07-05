# Opacity AVS Mainnet Node Setup Guide

For support contact @EulerLagrange217 on telegram

[Opacity AVS](https://app.eigenlayer.xyz/avs/0xCE06c5fe42d22fF827A519396583Fd9f5176E3D3)

## Introduction

Node Specs Recommended:

<img width="728" alt="Opacity Specs" src="https://github.com/OpacityLabs/opacity-avs-operator-setup/blob/main/assets/specs.png?raw=true">

The Opacity node must be run with a Intel SGX with SGX2 enabled. If you want to use a cloud provider, please use one of these:

- [Azure](https://learn.microsoft.com/en-us/azure/confidential-computing/quick-create-portal): Standard_DC2s_v2 is recommended
- [OVH](https://help.ovhcloud.com/csm/en-dedicated-servers-intel-sgx?id=kb_article_view&sysparm_article=KB0044005)
- [Fleek Network](https://fleek.xyz)
- [IBM](https://cloud.ibm.com/docs/bare-metal?topic=bare-metal-bm-server-provision-sgx)

We recommend you use Ubuntu 22.04

We DO NOT support AWS Enclaves!

## Clone this repo

```bash
git clone https://github.com/OpacityLabs/opacity-avs-operator-setup && cd opacity-avs-operator-setup
```

## Check SGX

First we should check you are on a valid SGX machine.

Go to [Fortanix](https://support.fortanix.com/hc/en-us/articles/4414753648788-SGX-Detect-Tool) and download the binary for your operating system.

For Ubuntu 22.04:

```bash
wget https://download.fortanix.com/sgx-detect/ubuntu22.04/sgx-detect?_gl=1*1saf6me*_gcl_au*NDAwNTE3NzE0LjE3MTk1MjQyNDQ -O sgx-detect
chmod +x sgx-detect
sudo ./sgx-detect
```

You should see:

<img width="418" alt="sgx-detect" src="https://github.com/OpacityLabs/opacity-avs-operator-setup/blob/main/assets/sgx.png?raw=true">

If you see any red on the output, please follow the guide here: [SGX Guide](https://github.com/OpacityLabs/opacity-avs-operator-setup/blob/main/SGX.md)

otherwise contact @EulerLagrange217 on telegram

## Install Go+EigenLayer cli

This step might be optional, so read carefully.

The binaries for the two CLI tools are provided bin folder of this repo. Since these binaries will handle private keys or may not execute correctly we've provided instructions to build them yourself in: [CLI Guide](https://github.com/OpacityLabs/opacity-avs-operator-setup/blob/main/INSTALL-CLI.md)


## Register Node Operator with EigenLayer mainnet

Before we can run a node, you must register your keys as an operator with EigenLayer mainnet. Please follow this guide: [Register Operator Guide](https://github.com/OpacityLabs/opacity-avs-operator-setup/blob/main/REGISTER-EIGEN.md)


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




## Install Docker

Using docker will make it much easier to manage the lifetime of your node operations, as well as seamlessly apply updates.

Use this guide: [Docker Install Guide](https://docs.docker.com/engine/install/linux-postinstall/)

## Run Opacity Node

### Update Config

There is one config value you must set manually in config/mainnet/opacity.mainnet.config.yaml

```yaml
# Set this (no quotes needed)
node_public_ip: your.ip.public.address
```

### Start the Docker container

```sh
#! Make sure these are correct
export OPERATOR_ECDSA_KEY_PASSWORD="your password"
export OPERATOR_BLS_KEY_PASSWORD="your password"

#! Make sure these are correct
export OPERATOR_ECDSA_KEY_FILE=$HOME/.eigenlayer/operator_keys/opacity.ecdsa.key.json
export OPERATOR_BLS_KEY_FILE=$HOME/.eigenlayer/operator_keys/opacity.bls.key.json
```

Run:

```bash
make start-container
```

OR

```bash
# Make sure you're on the latest image
docker pull opacitylabseulerlagrange/opacity-avs-node:mainnet

docker run -it \
    --device /dev/sgx_enclave \
    --device /dev/sgx_provision \
    --volume $OPERATOR_ECDSA_KEY_FILE:/opacity-avs-node/config/opacity.ecdsa.key.json \
    --volume $OPERATOR_BLS_KEY_FILE:/opacity-avs-node/config/opacity.bls.key.json \
    --volume ./config/mainnet/opacity.mainnet.config.yaml:/opacity-avs-node/config/opacity.config.yaml \
    -e OPERATOR_ECDSA_KEY_PASSWORD=$OPERATOR_ECDSA_KEY_PASSWORD \
    -e OPERATOR_BLS_KEY_PASSWORD=$OPERATOR_BLS_KEY_PASSWORD \
    -p 7047:7047 opacitylabseulerlagrange/opacity-avs-node:mainnet
```

add a `-d` to start it in the background.

This should start off the container

To check if it is still alive run:

```bash
docker container ls -la
```

To get the logs from a container

```bash
docker logs --since=1h <container-id>
```

If all looks good go to https://your-node-public-ip:7047

You should see:

<img width="640" alt="running node" src="https://github.com/OpacityLabs/opacity-avs-operator-setup/blob/main/assets/running-node.png?raw=true">

## View Node Logs

Once your container is running, we've included some commands to view the logs.

Run:

```bash
make show-node-logs
```

OR

```bash
docker logs --since=1h opacity-avs
```

The following command will also dump all the logs into a `opacity-avs-node.log` file:

```bash
make dump-node-logs
```

OR

```bash
docker logs opacity-avs >& opacity-avs-node.log
```
