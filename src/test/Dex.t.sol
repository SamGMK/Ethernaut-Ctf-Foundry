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
        address levelAddress = ethernaut.createLevelInstance(dexFactory);
        Dex dexContract = Dex(payable(levelAddress));
    }
}