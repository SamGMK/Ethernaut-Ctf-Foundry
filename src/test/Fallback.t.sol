//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut-x-foundry/src/Fallback/FallbackFactory.sol";
import "ethernaut-x-foundry/src/Ethernaut.sol";


contract FallbackTest is DSTest {
 
 //State variables
    Vm vm = Vm(address(HEVM_ADDRESS)); //special foundry address to call our cheats on
    Ethernaut ethernaut;
    address eoaAddress = address(1337); //addr we will use as msg.sender


   //SetUp
    function setUp() public {
        
        ethernaut = new Ethernaut(); //setup a new instance of Ethernaut
        vm.deal (eoaAddress, 1 ether); //give your msg.sender address eth for gas and other operations

    }
   
   
   //Test
   function testFallbackHack() public {
       //LEVEL SETUP
  
       

   }

}


