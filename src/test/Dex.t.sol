//SPDX-Lincense-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/Dex/DexFactory.sol";
import "ethernaut/Dex/DexHack.sol";

contract DexTest is DSTest {
    Vm vm = Vm(HEVM_ADDRESS);
    Ethernaut ethernaut;

    function setUp() public {
        ethernaut = new Ethernaut();
    }

    function testDexHack() public {
        //LEVEL SETUP
        DexFactory dexFactory = new DexFactory();
        ethernaut.registerLevel(dexFactory);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(dexFactory);
        Dex dexContract = Dex(payable(levelAddress));
        DexHack dexHackContract = new DexHack(dexContract);

        //LEVEL ATTACK
        IERC20(dexContract.token1()).transfer(address(dexHackContract), IERC20(dexContract.token1().balanceOf(address(this))));
        IERC20(dexContract.token2()).transfer(address(dexHackContract), IERC20(dexContract.token2().balanceOf(address(this))));

        dexHackContract.attack();

        //LEVEL SUBMISSION
        bool challengeCompleted = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        assert(challengeCompleted);
    }
}