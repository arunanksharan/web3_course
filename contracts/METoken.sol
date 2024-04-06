// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract METoken is ERC20, Ownable {
    string public constant name = "Mastering Ethereum Token";
    string public constant symbol = "MET";
    uint8 public constant decimals = 2;
    uint constant _initial_supply = 2100000000;

    // function METoken() public {
    //     totalSupply_ = _initial_supply;
    //     balances[msg.sender] = _initial_supply;
    //     emit Transfer(address(0), msg.sender, _initial_supply);
    // }

    constructor() {
        totalSupply_ = _initial_supply;
        balances[msg.sender] = _initial_supply; // Owner of METoken
        emit Transfer(address(0), msg.sender, _initial_supply);
    }
}
