# Install Go and EigenLayer CLI

The flow is roughly

```bash
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -xvf go1.21.0.linux-amd64.tar.gz -C /usr/local
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
go install github.com/Layr-Labs/eigenlayer-cli/cmd/eigenlayer@latest
mv $HOME/go/bin/eigenlayer ./bin/
```


# Warning

If you login to your server later on, you may need to set these env vars:

```bash
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```

Or just add them to your .bashrc

```bash
echo -e "\nexport GOBIN=\$GOPATH/bin\nexport PATH=\$GOBIN:\$PATH" >> $HOME/.bashrc
source $HOME/.bashrc
```
