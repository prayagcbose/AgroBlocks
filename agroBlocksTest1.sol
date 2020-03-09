pragma solidity ^0.4.17;
pragma experimental ABIEncoderV2;
contract AgroBlocks{
    
//declarations

    address public manager;
    uint public memberCount = 0;
    uint public productCount = 0;
    Member[] public members;
    mapping(address => bool) public memberPresent;
    mapping(uint => Product) public findPrd;
    Product[] public products;
    uint[] temp = [0];
    uint public shipmentCount = 0;
    Shipment[] public shipments;
    
//Structs

    struct Member{
        address memberAddress;
        uint memberId;
        uint shipmentCount;
        uint shipmentCountSuccess;
    }
    
    struct Product{
        uint id;
        string name;
        uint[] shipments;
        uint[] ingrediants;
    }
    
    struct Shipment{
        uint id;
        uint productId;
        address sender;
        address receiver;
        uint timestamp;
        bool success;
    }
    
//Functions
    constructor() public{
        manager = msg.sender;
    }
    
    function addMember()public {
        Member memory newMember = Member({
            memberAddress: msg.sender,
            memberId: memberCount+1,
            shipmentCount: 0,
            shipmentCountSuccess:0
        });
        memberCount++;
        members.push(newMember);
        memberPresent[newMember.memberAddress] = true;
    }
    
    function addProduct(string name) public{
        require(memberPresent[msg.sender]);
        Product memory newProduct = Product({
            id: productCount+1,
            name: name,
            shipments: temp,
            ingrediants: temp
        });
        findPrd[newProduct.id] = newProduct;
        products.push(newProduct);
        productCount++;
    }
    
    function addShipment(uint productId,address receiver) public{
        Shipment memory newShipment = Shipment({
            receiver:receiver,
            productId: productId,
            id: shipmentCount + 1,
            sender: msg.sender,
            timestamp: now,
            success: false
        });
        shipments.push(newShipment);
        shipmentCount++;
        findPrd[productId].shipments.push(newShipment.id);
    }
    
    function getProductDetails(uint id) public view returns(uint,string,uint[]){
        Product storage product = findPrd[id];
        return(product.id,product.name,product.shipments);
    }
    
    function getShipmentDetails(uint id) public view returns(Shipment){
        return(shipments[id-1]);
    }
    
}