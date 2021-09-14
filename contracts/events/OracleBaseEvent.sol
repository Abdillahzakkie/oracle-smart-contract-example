// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract OracleBaseEvent {
    event RequestEtherPrice(address user, uint256 indexed requestId, uint256 timestamp);
    event UpdateEtherPrice(uint256 indexed etherPrice, uint256 timestamp);
}