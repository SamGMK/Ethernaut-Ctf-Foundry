//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/GatekeeperTwo/GatekeeperTwoFactory.sol";
import "ethernaut/GatekeeperTwo/GatekeeperTwoHack.sol";

contract GatekeeperTwoTest is DSTest {
    //state variable
    Vm vm = Vm(address(HEVM_ADDRESS));
    Ethernaut ethernaut;
    

    //setup state variables
    function setUp() public {
        ethernaut = new Ethernaut();
    }

    //level setup,attack and submission
    function testGatekeeperTwoHack() public {
        //LEVEL SETUP
        GatekeeperTwoFactory gatekeeperTwoFactory = new GatekeeperTwoFactory();
        ethernaut.registerLevel(gatekeeperTwoFactory);
        vm.startPrank(tx.origin);

        
        address levelAddress = ethernaut.createLevelInstance(gatekeeperTwoFactory);
        GatekeeperTwo gatekeeperTwoContract = GatekeeperTwo(payable(levelAddress));
        vm.stopPrank();

        //LEVEL ATTACK
        GatekeeperTwoHack gatekeeperTwoHackContract = new GatekeeperTwoHack(levelAddress);



        //LEVEL SUBMISSION
        vm.startPrank(tx.origin);
        bool challengeCompleted = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        vm.stopPrank();
        assert(challengeCompleted);

    }


}