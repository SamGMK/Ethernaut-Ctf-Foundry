//SPDX-Lincense-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/King/KingFactory.sol";
import "ethernaut/King/KingHack.sol";

contract KingTest is DSTest {
    //state variables
    Vm vm = Vm(address(HEVM_ADDRESS));
    Ethernaut ethernaut;
    address attacker = address(0xbabe);

    //set up the variables above
    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    //level set up, attack and submission
    function testVaultHack() public {
        //LEVEL SET UP
    }
}