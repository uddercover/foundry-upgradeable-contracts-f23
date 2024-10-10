// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOcha} from "../script/DeployOcha.s.sol";
import {UpgradeOcha} from "../script/UpgradeOcha.s.sol";
import {OchaV1} from "../src/OchaV1.sol";
import {OchaV2} from "../src/OchaV2.sol";

contract DeployAndUpgradeOchaTest is Test {
    DeployOcha public deployer;
    UpgradeOcha public upgrader;
    address public OWNER = makeAddr("owner");

    address public proxy;

    // Remove deployerKey from vm.startBroadcast() in scripts for tests to work
    function setUp() public {
        deployer = new DeployOcha();
        upgrader = new UpgradeOcha();
        proxy = deployer.run();
    }

    function testProxyStartAsBoxV1() public {
        vm.expectRevert();
        OchaV2(proxy).setNumber(7);
    }

    function testUpgrades() public {
        OchaV2 ocha2 = new OchaV2();

        upgrader.upgradeOcha(proxy, address(ocha2));

        uint256 expectedValue = 2;
        assertEq(expectedValue, OchaV2(proxy).version());

        OchaV2(proxy).setNumber(7);
        assertEq(7, OchaV2(proxy).getNumber());
    }
}
