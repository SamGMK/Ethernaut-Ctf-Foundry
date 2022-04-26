//SPDX-Lincense-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/CoinFlip/CoinFlipFactory.sol";
import "ethernaut/CoinFlip/CoinFlipHack.sol";


contract CoinFlipTest is DSTest {
    //Declare state varibale you will use
    Vm vm = Vm(address(HEVM_ADDRESS));
    Ethernaut ethernaut;
    address attacker = address(0xbabe);

    //Set up the variable in the setup function
    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    //write your attack here
    function testCoinFlipHack() public {
        //LEVEL SETUP
        CoinFlipFactory coinFlipFactory = new CoinFlipFactory();
        ethernaut.registerLevel(coinFlipFactory);
        vm.startPrank(attacker);

        address levelAddress = ethernaut.createLevelInstance(coinFlipFactory);
        CoinFlip coinFlipContract = CoinFlip(payable(levelAddress));

        //LEVEL ATTACK
        CoinFlipHack coinFlipHack = new CoinFlipHack(levelAddress);
        uint BLOCK_START = 100;
        vm.roll(BLOCK_START); // cheatcode to prevent block 0 from giving us arithmetic error

        for(uint i = BLOCK_START; i < BLOCK_START + 10; ++i) {
         vm.roll(i + 1); //cheatcode to simulate the attack on each subsequent block
         coinFlipHack.attack();
        }

        assertEq(coinFlipContract.consecutiveWins(), 10);



        //LEVEL SUBMISSION
        bool challengeCompleted = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        assert(challengeCompleted);

  
         

    }





    
}