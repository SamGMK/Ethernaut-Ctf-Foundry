//SPDX-Lincense-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/Token/TokenFactory.sol";

contract TokenHack is DSTest {
    //state variables needed
    Vm vm = Vm(address(HEVM_ADDRESS));
    Ethernaut ethernaut;
    address attacker = address(0xbabe);

    //Set up function
    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    //test attack for token contract
    function testTokenHack() public {
        //LEVEL SETUP
        TokenFactory tokenFactory = new TokenFactory();
        ethernaut.registerLevelInstance(tokenFactory);
        vm.startPrank(attacker);

        address levelAddress = ethernaut.createLevelInstance(tokenFactory);
        Token tokenContract = Token(payable(levelAddress));
    }
}