var Animal = artifacts.require("Animal");

module.exports = function(deployer) {
  deployer.deploy(Animal);
};