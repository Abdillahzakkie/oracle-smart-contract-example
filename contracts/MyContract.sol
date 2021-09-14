// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "./OracleBase.sol";
import "hardhat/console.sol";

contract MyContract is OracleBase {
    uint256 public EtherPrice;

    function getEtherPrice() external {
        requestEtherPrice();
    }

    function fulfill(uint256 price) internal virtual override {
        EtherPrice = price;
    }
}