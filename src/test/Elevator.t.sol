//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/Elevator/ElevatorFactory.sol";
import "ethernaut/Elevator/ElevatorHack.sol";

contract ElevatorTest is DSTest {
    //state Variables
    Vm vm = Vm(address(HEVM_ADDRESS));
    Ethernaut ethernaut;
    address attacker = address(0xbabe);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    //test for level solution
    function testElevatorHack() public {
        //LEVEL SETUP
        ElevatorFactory elevatorFactory = new ElevatorFactory();
        ethernaut.registerLevel(elevatorFactory);
        

        address levelAddress = ethernaut.createLevelInstance(elevatorFactory);
        Elevator elevatorContract = Elevator(levelAddress);

        //LEVEL ATTACK
        ElevatorHack elevatorHackAddress = new ElevatorHack(address(levelAddress));
        elevatorHackAddress.attack();

        //LEVEl SUBMISSION
        bool challengeCompleted = ethernaut.submitLevelInstance(
             payable(levelAddress)
        );
        assert(challengeCompleted)'
        


    }
    
}