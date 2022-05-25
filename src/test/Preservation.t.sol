//SPDX-Lincense-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/Preservation/PreservationFactory.sol";
import "ethernaut/Preservation/PreservationHack.sol";

contract PreservationTest is DSTest{
    //state variables
    Vm vm = Vm(HEVM_ADDRESS);
    Ethernaut ethernaut;


    //setup state variables
    function setUp() public {
        ethernaut = new Ethernaut();
    }

    //test function
    function testPresevationHack() public {
        //LEVEL SETUP
        PreservationFactory preservationFactory = new PreservationFactory();
        ethernaut.registerLevel(preservationFactory);
        address levelAddress = ethernaut.createLevelInstance(preservationFactory);
        Preservation preservationContract = Preservation(levelAddress);

        PreservationHack preservationHackContract = new PreservationHack(levelAddress);

        //LEVEL ATTACK
        preservationHackContract.attack();

        //LEVEL SUBMISSION
        bool challengeCompleted = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        assert(challengeCompleted);
    }
}