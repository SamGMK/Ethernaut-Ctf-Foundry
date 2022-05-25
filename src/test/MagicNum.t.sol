//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/MagicNum/MagicNumFactory.sol";

contract MagicNumTest is DSTest {
    Vm vm = Vm(HEVM_ADDRESS);
    Ethernaut ethernaut;

    //setup function
    function setUp() public{
        ethernaut = new Ethernaut();
    }

    //level setup, attack and submission
    function testMagicNumHack() public{
        //LEVEL SETUP
        MagicNumFactory magicNumFactory = new MagicNumFactory();
        ethernaut.registerLevel(magicNumFactory);
        address levelAddress = ethernaut.createLevelInstance(magicNumFactory);
        MagicNum magicNumContract = MagicNum(levelAddress);

        //LEVEL ATTACK
        //****** Runtime bytecode ******
        
        //Mstore(data and location)
        //data is 42.  
        //location is 0x80(memory slot)
        //6042 push 42
        //6080 push 0x80
        //52 mstore 
        //Return(size and location)
        //size is 32 bytes 0x20
        //location is 0x80(memory slot)
        //6020 push 20
        //6080 push 0x80
        //f3 return
        //Runtime bytecode is 604260805260206080f3

        //****** Initializiation Bytecode *******

        //Codecopy(size, position,destination)
        // size is 10 bytes or 0x0a
        //position is currently unknown or 0x??
        //destination is 0x00
        //600a push 0x0a
        //60?? push 0x??
        //6000 push 0x00
        //39 CODECOPY
        //Return(size and location)
        // size is 10 bytes or 0x0a
        //location is 0x00
        //600a push 0x0a
        //6000 push 0x00
        //f3 Return
        //Initilization bytecode is 600a600c600039600a6000f3

        //total bytecode is 600a600c600039600a6000f3604260805260206080f3

        //use create2 to create the contract, salt = 0 and then pass in contract address as solver

       bytes memory bytecode = "\x60\x0a\x60\x0c\x60\x00\x39\x60\x0a\x60\x00\xf3\x60\x2a\x60\x80\x52\x60\x20\x60\x80\xf3";
       address solver;
       bytes32 salt = 0;

       assembly { 
           solver := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
       } 
       magicNumContract.setSolver(solver);


       //LEVEL SUBMISSION
       bool challengeCompleted = ethernaut.submitLevelInstance(
           payable(levelAddress)
       );
       assert(challengeCompleted);
    }
}