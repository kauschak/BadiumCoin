var BadiumCoin = artifacts.require("Badium");

module.exports = function(deployer) {
    deployer.deploy(BadiumCoin);
    // Additional contracts can be deployed here
};
