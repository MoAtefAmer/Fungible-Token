include .env
export 

run:;anvil

.PHONY: tests 
tests:;forge test -vv

.PHONY: all test clean deploy fund help install snapshot format anvil 
test:;forge test  --match-test ${t} -vvv
# Show storage of contract
cast-storage:;cast storage ${c}

# Deploy on chain
deploy-rpc:;forge script ${dir} --rpc-url ${ch}	--private-key ${pk} --broadcast 
# --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvv

# deploy:;forge script ${dir}



coverage-report:; forge coverage --report debug > coverage.txt


tests-sepolia:;forge test --fork-url $$SEPOLIA_RPC_URL



test-sepolia:;forge test --match-test ${t} -vv --fork-url $$SEPOLIA_RPC_URL 
	 


coverage:;forge coverage --fork-url $$SEPOLIA_RPC_URL

snapshot:;forge snapshot # gas snapshot; how much gas will this test cost 


storage-layout:;forge inspect ${c} storageLayout


foundry-devops:;forge install ChainAccelOrg/foundry-devops --no-commit

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast
.PHONY: deploy
deploy:;@forge script script/DeployMyToken.s.sol:DeployMyToken $(NETWORK_ARGS)