//SPDX-Lincense-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/Shop/ShopFactory.sol";
import "ethernaut/Shop/ShopHack.sol";

contract ShopTest is DSTest {
    //state variables 
    Vm vm = Vm(HEVM_ADDRESS);
    Ethernaut ethernaut;


    //setup state variables
    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testShopHack() public {
        //LEVEL SETUP
        ShopFactory shopFactory = new ShopFactory();
        ethernaut.registerLevel(shopFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(shopFactory);
        Shop shopContract = Shop(levelAddress);

        //LEVEL ATTACK
        ShopHack shopHackContract = new ShopHack(shopContract);

        shopHackContract.attack();

        //LEVEL SUBMISSION
        bool challengeCompleted = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        assert(challengeCompleted);
    }
}

