pragma solidity >=0.5.0 <0.6.0;

import "truffle/Assert.sol"; 
import "truffle/DeployedAddresses.sol";
import "../contracts/Badium.sol";

contract TestBadium {
    Badium private badiumTest;
    address private ownerAddress;
    address private receiver1Address;
    address private receiver2Address;
    address payable private changeOwnerAddress;

    function beforeAll() public {
        badiumTest = new Badium();
        ownerAddress = badiumTest.owner();
        receiver1Address = 0x9272cbA35d6439c706F4A12dF6B3c615C6A40f1e;
        receiver2Address = 0x1F2e3Bb9EB02c3BEAd945Ff4AE0A609dFfD45931;
        changeOwnerAddress = 0x1a436F0BC7d8A3675A6628aF0a2B069153fB1E64;
    }
    
    function beforeEach() public {
        badiumTest.addReceiver(receiver1Address);
    }
    
    function afterEach() public {
        badiumTest.removeReceiver(receiver1Address);
    }
    
    function testOwner() public {
        Assert.equal(badiumTest.owner(), ownerAddress, "Badium Owner Address mismatch");
    }
    
    function testName() public {
        Assert.equal(badiumTest.name(), "Badium", "Badium Name mismatch");
    }

    function testSymbol() public {
        Assert.equal(badiumTest.symbol(), "BAD", "Badium Symbol mismatch");
    }
    
    function testDecimals() public {
        uint256 decimalValue = 0;
        Assert.equal(badiumTest.decimals(), decimalValue, "Badium Decimals mismatch");
    }
    
    function testTotalSupply() public {
        uint256 totalSupplyValue = 10000000;
        Assert.equal(badiumTest.totalSupply(), totalSupplyValue, "Badium Total Supply mismatch");
    }
    
    function testAddReceiver() public {
        bool result = badiumTest.addReceiver(receiver2Address);
        Assert.equal(result, true, "Badium Add receiver failed");
    }
    
    function testRemoveReceiver() public {
        bool result = badiumTest.removeReceiver(receiver2Address);
        Assert.equal(result, true, "Badium Remove receiver failed");
    }
    
    function testTransferAndBalanceOf() public {
        uint256 balanceOfReceiver = badiumTest.balanceOf(receiver1Address);
        uint256 balanceOfOwner = badiumTest.balanceOf(ownerAddress);
        badiumTest.transfer(receiver1Address, 50);
        Assert.equal(badiumTest.balanceOf(receiver1Address), balanceOfReceiver + 50, "Badium Transfer value mismatch with balance");
        Assert.equal(badiumTest.balanceOf(ownerAddress), balanceOfOwner - 50, "Badium Transfer value mismatch with owner balance");
    }
    
    function testApproveAndAllowance() public {
        badiumTest.approve(receiver1Address, 10);
        Assert.equal(badiumTest.allowance(ownerAddress, receiver1Address), 10, "Badium Approved allowance value mismatch");
    }
    
    function testMint() public {
        uint256 existingTotalSupply = badiumTest.totalSupply();
        badiumTest.mint(1000);
        Assert.equal(badiumTest.totalSupply(), existingTotalSupply + 1000, "Badium Total Supply mismatch while mint");
    }
    
    function testBurn() public {
        uint256 balanceOfReceiver = badiumTest.balanceOf(receiver1Address);
        uint256 existingTotalSupply = badiumTest.totalSupply();
        badiumTest.burn(receiver1Address, 20);
        Assert.equal(badiumTest.balanceOf(receiver1Address), balanceOfReceiver - 20, "Badium burn value mismatch for Receiver");
        Assert.equal(badiumTest.totalSupply(), existingTotalSupply - 20, "Badium Total Supply mismatch post burn");
    }
    
    function testBurnAll() public {
        uint256 currentCirculatorySystem = badiumTest.getCurrentCirculatorySystem();
        badiumTest.burnAll();
        Assert.equal(badiumTest.totalSupply(), 0, "Badium Total Supply must be 0 post Burn All");
        Assert.equal(badiumTest.balanceOf(receiver1Address), 0, "Receiver should have 0 token post Burn All");
        Assert.equal(badiumTest.getCurrentCirculatorySystem(), currentCirculatorySystem + 1, "Badium Token Circuatory System must increament post Burn All");
    }
    
    function testSelectCurrentCirculatorySystem() public {
        uint256 currentCirculatorySystem = badiumTest.getCurrentCirculatorySystem();
        badiumTest.selectCirculatorySystem(currentCirculatorySystem - 1);
        Assert.equal(badiumTest.getCurrentCirculatorySystem(), 0, "Badium Circulatory System mismatch");
        require(badiumTest.totalSupply() > 0, "Badium Total Supply must be greater than 0 as old circulatory system is back");
        require(badiumTest.balanceOf(receiver1Address) > 0, "Receiver should have greater than 0 as old circulatory system is back");
    }
    
    /*function testBuy() public {
        badiumTest.transferOwnership(changeOwnerAddress);
        uint256 ownerBalance = changeOwnerAddress.balance;
        uint256 receiverBalance = ownerAddress.balance;
        badiumTest.buy.value(0.01 ether)(1);
        Assert.equal(changeOwnerAddress.balance, ownerBalance + 1, "Badium Owner ether balance must increase by 1 ether as exhange rate is 0.01 ether");
        Assert.equal(ownerAddress.balance, receiverBalance + 1, "Badium receiver ether balance must decrease by 1 ether as exhange rate is 0.01 ether");
    }*/
    
}

