Description
-----------
The requirements for the test project: <Not completed yet>

Create a smart contract for a new ERC20 token called Badium (BAD). The contract needs to be deployed to testnet before the interview. The token will have following characteristics:

- An initial total supply of 10,000,000.
- A buying cost of 0.01 ETH per BAD.
- The owner can burn all tokens at any time.
- The owner can mint arbitrary amount of tokens at any time.
- The owner can transfer tokens from one address to another.
- The owner can specify and modify a list of eligible receivers. Once bought by users, tokens can be transferred only to those addresses.
- Whatever parameters are not defined in the task are left for you to decide on your own, while making sure they benefit the contract’s architecture.
- The Smart Contract enables mining of BAD token by a basic Proof of Work process.

Environment Preperation
-----------------------
Used Ubuntu VM in GCP.
Deployed contract in Ropsten (POW testnet) network.

Softwares requirements
1. Truffle
2. Truffle hdwallet provider
3. Metamask

Installation steps
```
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install -g truffle
sudo npm install --save truffle-hdwallet-provider
```


Build & deployment of Contract
------------------------------
```
mkdir BadiumCoin
cd BadiumCoin
truffle init
truffle compile
truffle deploy --network ropsten
```
Register Reciever for Badium tokens
-----------------------------------
```
truffle console --network ropsten

Badium.deployed().then(function(instance){return instance });
Badium.deployed().then(function(instance){return instance.addReceiver("0x63249b8F042e2FDebF7d3fD7001Ad234CE57A75a")});
Badium.deployed().then(function(instance){return instance.addReceiver("0xf94258cECD257EEcE5498326028a82776dBfe309")});
```

Manual Testing Steps in Development
-----------------------------------
```
truffle console --network develpoment

Badium.deployed().then(function(instance){return instance.addReceiver("0x9272cbA35d6439c706F4A12dF6B3c615C6A40f1e")});
Badium.deployed().then(function(instance){return instance.addReceiver("0x1a436F0BC7d8A3675A6628aF0a2B069153fB1E64")});
Badium.deployed().then(function(instance){return instance.balanceOf("0x9272cbA35d6439c706F4A12dF6B3c615C6A40f1e")});
Badium.deployed().then(function(instance){return instance.balanceOf("0x1a436F0BC7d8A3675A6628aF0a2B069153fB1E64")});
Badium.deployed().then(function(instance){return instance.owner()});
Badium.deployed().then(function(instance){return instance.name()});
Badium.deployed().then(function(instance){return instance.symbol()});
Badium.deployed().then(function(instance){return instance.decimals()});
Badium.deployed().then(function(instance){return instance.totalSupply()});
Badium.deployed().then(function(instance){return instance.mint(1000)});
Badium.deployed().then(function(instance){return instance.buy(100, {from: "0x9272cbA35d6439c706F4A12dF6B3c615C6A40f1e", value: web3.utils.toWei("1", 'ether')})});
Badium.deployed().then(function(instance){return instance.balanceOf("0x9272cbA35d6439c706F4A12dF6B3c615C6A40f1e")});
Badium.deployed().then(function(instance){return instance.buy(200, {from: "0x1a436F0BC7d8A3675A6628aF0a2B069153fB1E64", value: web3.utils.toWei("2", 'ether')})});
Badium.deployed().then(function(instance){return instance.balanceOf("0x1a436F0BC7d8A3675A6628aF0a2B069153fB1E64")});
Badium.deployed().then(function(instance){return instance.transfer("0x9272cbA35d6439c706F4A12dF6B3c615C6A40f1e", 50, {from: "0x1a436F0BC7d8A3675A6628aF0a2B069153fB1E64"})});
Badium.deployed().then(function(instance){return instance.approve("0x9272cbA35d6439c706F4A12dF6B3c615C6A40f1e", 50, {from: "0x1a436F0BC7d8A3675A6628aF0a2B069153fB1E64"})});
Badium.deployed().then(function(instance){return instance.allowance("0x1a436F0BC7d8A3675A6628aF0a2B069153fB1E64", "0x9272cbA35d6439c706F4A12dF6B3c615C6A40f1e")});
Badium.deployed().then(function(instance){return instance.transferFrom("0x1a436F0BC7d8A3675A6628aF0a2B069153fB1E64", "0x9272cbA35d6439c706F4A12dF6B3c615C6A40f1e", 25, {from: "0x9272cbA35d6439c706F4A12dF6B3c615C6A40f1e"})});
Badium.deployed().then(function(instance){return instance.burn("0x9272cbA35d6439c706F4A12dF6B3c615C6A40f1e", 200)});
Badium.deployed().then(function(instance){return instance.burn("0x9272cbA35d6439c706F4A12dF6B3c615C6A40f1e", 100)});
Badium.deployed().then(function(instance){return instance.balanceOf("0x1a436F0BC7d8A3675A6628aF0a2B069153fB1E64")});
Badium.deployed().then(function(instance){return instance.balanceOf("0x9272cbA35d6439c706F4A12dF6B3c615C6A40f1e")});
Badium.deployed().then(function(instance){return instance.totalSupply()});
Badium.deployed().then(function(instance){return instance.getCurrentCirculatorySystem()});
Badium.deployed().then(function(instance){return instance.burnAll()});
Badium.deployed().then(function(instance){return instance.totalSupply()});
Badium.deployed().then(function(instance){return instance.balanceOf("0x9272cbA35d6439c706F4A12dF6B3c615C6A40f1e")});
Badium.deployed().then(function(instance){return instance.getCurrentCirculatorySystem()});
Badium.deployed().then(function(instance){return instance.selectCirculatorySystem(0)});
Badium.deployed().then(function(instance){return instance.totalSupply()});
Badium.deployed().then(function(instance){return instance.balanceOf("0x9272cbA35d6439c706F4A12dF6B3c615C6A40f1e")});
Badium.deployed().then(function(instance){return instance.getCurrentCirculatorySystem()});
```


