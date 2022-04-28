//SPDX-Lincense-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/Force/ForceFactory.sol";
import "ethernaut/Force/ForceHack.sol";

 contract ForceTest is DSTest {
    //state variable needed
    Vm vm = Vm(address(HEVM_ADDRESS));
    Ethernaut ethernaut;
    address attacker = address(0xbabe);

    //setUp variables above
    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    //level set up, attack and submission 
    function testForceHack() public {
        //LEVEL SET UP
        ForceFactory forceFactory = new ForceFactory();
        ethernaut.registerLevel(forceFactory);
        vm.startPrank(attacker);

        address levelAddress = ethernaut.createLevelInstance(forceFactory);
        Force forceHackContract = Force(payable(levelAddress));

        //LEVEL ATTACK
        ForceHack forceHack = (new ForceHack){value: 0.1 ether}(payable(levelAddress));
        

        //LEVEL SUBMISSION
        bool challengeCompleted = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        vm.stopPrank();
        assert(challengeCompleted);
        

    }
}
