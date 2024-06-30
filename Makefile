
.PHONY: install-eigenlayer-cli
install-eigenlayer-cli:
	@set -e
	@echo "Installing Go"
	@wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
	@sudo tar -xvf go1.21.0.linux-amd64.tar.gz -C /usr/local
	@export GOROOT=/usr/local/go
	@export GOPATH=$HOME/go
	@export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
	@go install github.com/Layr-Labs/eigenlayer-cli/cmd/eigenlayer@latest
	@mv $HOME/go/bin/eigenlayer ./bin/
	@echo -e "\nexport GOBIN=\$GOPATH/bin\nexport PATH=\$GOBIN:\$PATH" >> $HOME/.bashrc

.PHONY: generate-operator-keys
generate-operator-keys:
	@echo "Generating ECDSA Key"
	@bin/eigenlayer operator keys create --key-type ecdsa --insecure opacity
	@echo "Generating BLS Key"
	@bin/eigenlayer operator keys create --key-type bls --insecure opacity


.PHONY: create-operator-config
create-operator-config:
	@echo "Creating Operator Config"
	@bin/eigenlayer operator config create


.PHONY: register-eigen-operator
register-eigen-operator:
	@echo "Registering Operator to EigenLayer"
	@bin/eigenlayer operator register operator.yaml

register-opacity-node:
	@bin/avs-cli --config config/opacity.config.yaml register-operator-with-avs



.PHONY: list-keys
list-keys:
	@bin/eigenlayer operator keys list


.PHONY: generate-notary-keys
generate-notary-keys:
	@mkdir -p fixture/notary
	@echo "Generating Notary Keys"
	@./generate_notary_keys.sh


.PHONY: start-container
start-container:

#	@test -n "$(OPERATOR_ECDSA_KEY_PASSWORD)" || (echo "OPERATOR_ECDSA_KEY_PASSWORD is not set" && exit 1)
#	@test -n "$(OPERATOR_BLS_KEY_PASSWORD)" || (echo "OPERATOR_BLS_KEY_PASSWORD is not set" && exit 1)
	@test -n "$(OPERATOR_ECDSA_KEY_FILE)" || (echo "OPERATOR_ECDSA_KEY_FILE env var is not set" && exit 1)
	@test -n "$(OPERATOR_BLS_KEY_FILE)" || (echo "OPERATOR_BLS_KEY_FILE env var is not set" && exit 1)
	@docker run -d -it --name opacity-avs \ 
		--device /dev/sgx_enclave --device /dev/sgx_provision \
		--volume $(OPERATOR_ECDSA_KEY_FILE):/opacity-avs-node/opacity.ecdsa.key.json \
  		--volume $(OPERATOR_BLS_KEY_FILE):/opacity-avs-node/opacity.bls.key.json \
		--volume config/holesky/opacity.config.yaml:/opacity-avs-node/config/opacity.config.yaml \
		-e OPERATOR_ECDSA_KEY_PASSWORD=$(OPERATOR_ECDSA_KEY_PASSWORD) \
		-e OPERATOR_BLS_KEY_PASSWORD=$(OPERATOR_BLS_KEY_PASSWORD) \
		-p 7047:7047 \
  		opacitylabseulerlagrange/opacity-avs-node:latest


