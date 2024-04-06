// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract METFaucet is Ownable {
    IERC20 public METoken;
    address public METOwner; // Every faucet request - can only be approved by an owner

    constructor(address _METoken, address _METOwner) public {
        METoken = IERC20(_METoken);
        METOwner = _METOwner;
    }

    function withdraw(uint withdraw_amount) public {
        // Limiting the withdrawal amount to 10 MET => 1000 since decimals = 2
        require(withdraw_amount <= 1000);

        // Faucet => call transferFrom function of METoken
        METoken.transferFrom(METOwner, msg.sender, withdraw_amount);
    }

    // Safeguard: Reject any incoming ether
    function() public payable {
        revert();
    }
}
