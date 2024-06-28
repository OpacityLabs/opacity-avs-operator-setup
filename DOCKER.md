# Install Docker

See: [Docker docs](https://docs.docker.com/engine/install)

For Ubuntu 22.04:

```bash
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

On some machines you might be required to use sudo to run docker commands. 

This may cause issues with enviroment variables you have set, so we recommend you take the following steps to work with docker without sudo:

```bash
# This first one may have been done
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

See this guide if you run into issues [Docker Linux post-install](https://docs.docker.com/engine/install/linux-postinstall/)