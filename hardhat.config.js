/**
 * @type import('hardhat/config').HardhatUserConfig
 */

 require("@nomiclabs/hardhat-waffle");

 // Go to https://www.alchemyapi.io, sign up, create
 // a new App in its dashboard, and replace "KEY" with its key
 const ALCHEMY_API_KEY = "0LlZ3OuN32Tt7AOQdgj2syKnyMwsLP3O";
 
 // Replace this private key with your Goerli account private key
 // To export your private key from Metamask, open Metamask and
 // go to Account Details > Export Private Key
 // Be aware of NEVER putting real Ether into testing accounts
 const GOERLI_PRIVATE_KEY = "a1b1fd0ec299e0f6b7e4b198496cab117116366cd0586333c0884a0b4972c948";

module.exports = {
  solidity: "0.8.0",
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [`${GOERLI_PRIVATE_KEY}`]
    }
  }
};
