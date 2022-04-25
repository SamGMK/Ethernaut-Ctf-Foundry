//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/Fallout/FalloutFactory.sol";

contract FalloutTest {
    //state variables we will need 
    Vm vm = Vm(address(HEVM_ADDRESS));
    Ethernaut ethernaut;
    address attacker = address(0xbabe);

    //Set Up function
    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    //test for hacking level
    function testFalloutHack() public {
        FalloutFactory falloutFactory = new FalloutFactory();
        vm.startPrank(attacker);

        address levelAddress = ethernaut.createInstance(falloutFactory);
        Fallout falloutAddres = Fallout(payable(levelAdress));

        //Level Attack

        
    }
}