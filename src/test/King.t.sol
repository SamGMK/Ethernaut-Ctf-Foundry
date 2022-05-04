//SPDX-Lincense-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/King/KingFactory.sol";
import "ethernaut/King/KingHack.sol";

contract KingTest is DSTest {
    //state variables
    Vm vm = Vm(address(HEVM_ADDRESS));
    Ethernaut ethernaut;
    address attacker = address(0xbabe);

    //set up the variables above
    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 3 ether);
    }

    //level set up, attack and submission
    function testVaultHack() public {
        //LEVEL SET UP
        KingFactory kingFactory = new KingFactory();
        ethernaut.registerLevel(kingFactory);
        vm.startPrank(attacker);

        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(kingFactory);
        King kingContract = King(payable(address(levelAddress)));

        //LEVEL ATTACK
        KingHack kingHack = new KingHack(payable(address(levelAddress)));
        kingHack.attack{value: 2 ether}();
        
        address newKing = kingContract._king();
        assertEq(newKing, address(this));

        //LEVEL SUBMISSION
        bool challengeCompleted = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );

        assert(challengeCompleted);
        
    }
}