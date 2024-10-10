// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Script} from "forge-std/Script.sol";
import {OchaV1} from "../src/OchaV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployOcha is Script {
    //script that deploys v1 with proxy as its owner ---  deployProxy
    //script that deploys v2 and passes it to v1's upgrade function through the function to upgrade -- upgrade proxy

    function run() external returns (address) {
        address proxy = deployOcha();
        return proxy;
    }

    function deployOcha() internal returns (address) {
        HelperConfig config = new HelperConfig();
        (uint256 deployerKey) = config.activeNetworkConfig();

        vm.startBroadcast(deployerKey);
        address ochaV1 = address(new OchaV1());
        address proxy = address(new ERC1967Proxy(ochaV1, ""));
        vm.stopBroadcast();
        return proxy;
        //depoy proxy
        //proxy.setImplmentation(ochaV1);
        //proxy.initialize(proxy);
    }
}
