// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        // Mint 100 tokens to msg.sender
        _mint(msg.sender, 100 * 10**uint(decimals()));
    }
}

// la
// 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// lacoin
// 0xd9145CCE52D386f254917e481eB44e9943F39138

// be
// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// becoin
// 0xa131AD247055FD2e2aA8b156A11bdEc81b9eAD95