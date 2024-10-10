//SPDX-License-Identifier:MIT

pragma solidity 0.8.27;

import {Test, console} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;
    address public OWNER = makeAddr("Owner");

    address public proxy;

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();

        proxy = deployer.run(); // right now point to BoxV1
    }

    function test_proxyStartAsV1() public {
        assertEq(BoxV1(proxy).version(), 1);
    }

    function test_Upgrade() public {
        BoxV2 boxV2 = new BoxV2();

        upgrader.upgradeBox(proxy, address(boxV2));

        uint256 expectedversion = 2;
        uint256 actualVersion = BoxV2(proxy).version();
        assertEq(expectedversion, actualVersion);

        BoxV2(proxy).setNumber(10);
        assertEq(BoxV2(proxy).getNumber(), 10);
    }
}
