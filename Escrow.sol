// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

interface IERC721 {
    function transferFrom(address _from, address _to, uint256 _id) external;
    }
contract Escrow {

    address public nftAddress;
    uint256 public nftID;
    uint256 public PurchasePrice;
    uint256 public EscrowAmount;
    address payable public seller;
    address payable public buyer;
    address public lender;
    address public inspector;

modifier onlyBuyer() {

    require(msg.sender == buyer, "Only buyer can Call this function");
    _;
}

modifier onlyInspector() {

    require(msg.sender == inspector, "Only inspector can Call this function");
    _;
}

bool public inspectionPassed = false; 
mapping(address => bool) public approval;

receive() external payable{}

    constructor(
    address _nftaddress,
    uint256 _nftID,
    uint256 _purchasePrice,
    uint256 _escrowAmount,
    address payable _seller,
    address payable _buyer,
    address _lender,
    address _inspector
     ){
        nftAddress = _nftaddress;
        nftID = _nftID; 
        seller = _seller;
        buyer = _buyer;
        PurchasePrice = _purchasePrice;
        EscrowAmount = _escrowAmount;
        lender = _lender;
        inspector = _inspector;
    }

    

    function depositEarnest() public payable  {
       require(msg.value >= EscrowAmount);
    }

    function updateInspectionStatus(bool _passed) public onlyInspector{
        inspectionPassed = _passed;
    }

    function approveSale() public {
        approval [msg.sender] = true;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function finalizeSale() public {
        require(inspectionPassed, 'must pass inspection');
        require(approval[buyer], 'must be approved by the buyer');
        require(approval[seller], 'must be approved by the seller');
        require(approval[lender], 'must be approved by the lender');
        require(address(this).balance >= PurchasePrice, 'amount must be equal to the purchase price');
    
    
    (bool success, ) = payable(seller).call{value: address(this).balance}("");
        require(success);
    
    //Transfer Ownership of the Property 
    IERC721(nftAddress).transferFrom(seller, buyer, nftID);

    
    }
    

}
