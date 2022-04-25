//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

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
    ethernaut = new Ethernaut; //new instance of the Ethernaut game initiated
    vm.deal(1 ether, attacker); //give attacker account ether to pay for Txs
}
  

   














}
