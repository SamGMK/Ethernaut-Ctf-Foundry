//SPDX-Lincense-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/Denial/DenialFactory.sol";
import "ethernaut/Denial/DenialHack.sol";

contract DenialTest is DSTest {
    Vm vm = Vm(HEVM_ADDRESS);
    Ethernaut ethernaut;
    

    //setup function 
    function setUp() public {
        ethernaut = new Ethernaut();

    }

    function testDenialHack() public {
        //LEVEL SETUP
        DenialFactory denialFactory = new DenialFactory();
        ethernaut.registerLevel(denialFactory);
        address levelAddress = ethernaut.createLevelInstance{value:1 ether}(denialFactory);
        Denial denialContract = Denial(payable(address(levelAddress)));

        //LEVEL ATTACK
        DenialHack denialHackContract = new DenialHack();
        denialContract.setWithdrawPartner(address(denialHackContract));

        //LEVEL SUBMISSION
        bool challengeCompleted = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        assert(challengeCompleted);
    }
}