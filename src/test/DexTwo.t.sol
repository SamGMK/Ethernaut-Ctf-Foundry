//SPDX-Lincense-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/DexTwo/DexTwoFactory.sol";
import "ethernaut/DexTwo/DexTwoHack.sol";

contract DexTwoTest is DSTest {
    Vm vm = Vm(HEVM_ADDRESS);
    Ethernaut ethernaut;

    function setUp() public { 
        ethernaut = new Ethernaut();
    } 

    function testDexTwoHack() public {
        //LEVEL SETUP
        DexTwoFactory dexTwoFactory = new DexTwoFactory();
        ethernaut.registerLevel(dexTwoFactory);
        address levelAddress = ethernaut.createLevelInstance(dexTwoFactory);
        DexTwo dexTwoContract = DexTwo(levelAddress);

        //LEVEL ATTACK
        DexTwoHack dexTwoHack = new DexTwoHack(dexTwoContract);

        dexTwoHack.attack();

        //LEVEL SUBMISSION
        bool challengeCompleted = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        assert(challengeCompleted);
    }
    
}