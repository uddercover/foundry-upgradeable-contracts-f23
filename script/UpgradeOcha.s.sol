// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Script} from "forge-std/Script.sol";
import {OchaV1} from "../src/OchaV1.sol";
import {OchaV2} from "../src/OchaV2.sol";
import {DevOpsTools} from "@foundry-devops/src/DevOpsTools.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract UpgradeOcha is Script {
    //in run, get most recent proxy deployment using devops tools
    //in run, call upgradeOcha Function
    //in upgradeOcha, deploy ochaV2 (vm.startBroadcast() here)
    //in upgradeOcha, call upgradeTo on proxy with ochaV2 as the parameter (vm.startBroadcast() here as well ) remember to wrap in OchaV1 as we need it's abi
    //return OchaV2

    uint256 deployerKey;

    function run() external returns (address) {
        HelperConfig config = new HelperConfig();
        (deployerKey) = config.activeNetworkConfig();
        address proxy = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast(deployerKey);
        OchaV2 ochaV2 = new OchaV2();
        vm.stopBroadcast();

        upgradeOcha(proxy, address(ochaV2));
        return address(ochaV2);
    }

    function upgradeOcha(address proxy, address newOcha) public {
        vm.startBroadcast(deployerKey);
        OchaV1(proxy).upgradeToAndCall(newOcha, "");
        vm.stopBroadcast();
    }
}
