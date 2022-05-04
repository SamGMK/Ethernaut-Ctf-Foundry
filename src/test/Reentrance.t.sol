//SPDX-Lincense-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/Reentrance/ReentranceFactory.sol";
import "ethernaut/Reentrance/ReentranceHack.sol";

contract ReentranceTest is DSTest {
    //state variables
    Vm vm = Vm(address(HEVM_ADDRESS));
    Ethernaut ethernaut;
    address attacker = address(0xbabe);

    //set up state variables
    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    //test function
    function testReentranceHack() public {
        //LEVEL SET UP
        ReentranceFactory reentranceFactory = new ReentranceFactory();
        ethernaut.registerLevel(reentranceFactory);
        vm.startPrank(attacker);

        address levelAddress = ethernaut.createLevelInstance(reentranceFactory);
        Reentrance reentranceContract = Reentrance(payable(levelAddress));

        //LEVEL ATTACK
        ReentranceHack reentranceHackContract = new ReentranceHack(payable(levelAddress));
        reentranceHackContract.attack{value: 0.1 ether} ();


        //LEVEL SUBMISSION
        bool challengeCompleted = ethernaut.submitLevelInstance(
            payable(levelAddress)
            );
        vm.stopPrank();
        assert(challengeCompleted);

    }
}