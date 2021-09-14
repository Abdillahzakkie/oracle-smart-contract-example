// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./events/OracleBaseEvent.sol";

abstract contract OracleBase is AccessControl, OracleBaseEvent {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    bytes32 public constant ORACLE_CALLER = keccak256("ORACLE_CALLER");
    
    constructor() {
        _setupRole(ORACLE_CALLER, _msgSender());
    }
    
    function fulfill(uint256) internal virtual;

    function requestEtherPrice() internal virtual {
        emit RequestEtherPrice(_msgSender(), _tokenIdCounter.current(), block.timestamp);
        _tokenIdCounter.increment();
    }

    function execute(uint256 price) external {
        require(hasRole(ORACLE_CALLER, _msgSender()), "OracleBase: Access revoked for caller");
        emit UpdateEtherPrice(price, block.timestamp);
        fulfill(price);
    }
}