// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {UUPSUpgradeable} from "@openzeppelin/upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/upgradeable/contracts/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/upgradeable/contracts/access/OwnableUpgradeable.sol";

contract OchaV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 internal number;

    //necessary as the implementation should not have any logic that could potentially alter state in it's constructor
    constructor() {
        _disableInitializers();
    }

    //a way(alternative to a constructor) to set the proxy as the owner of this contract
    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() public pure returns (uint256) {
        return 1;
    }

    function _authorizeUpgrade(address newImplementation) internal override {}
}
