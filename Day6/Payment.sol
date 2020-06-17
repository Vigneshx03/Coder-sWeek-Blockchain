pragma solidity >=0.4.0 <0.7.0;
contract TransferMoney{
    address payable own;
    uint ownbal;
    mapping(address => uint) balance;
    
    constructor(uint _totalBal) public {
        own = msg.sender;
        ownbal = _totalBal;
        balance[own] = ownbal;
    }
    
    function getOwnerBalance() public checkOwner view returns(uint){
        // this function returns the balance left with the owner
        return balance[msg.sender];
    }
    
    function getContractBalance() public view returns(uint){
        // this function returns the balance left with the contract
        return address(this).balance;
    }
    
    event Pay(address indexed _sender, address indexed _receiver,uint value);
    
    // modifiers to check certain conditions before the function is processed
    modifier checkOwner{
        require(own==msg.sender,"owner not verified");
        _;
    }
    
    modifier checkMinimum(uint _transf){
         require(address(this).balance>=_transf,"insufficient funds with contract");
        _;
    }
    
    function checkBalance(address _address) public view returns(uint){
        // this function returns the balance left with the given address 
        return balance[_address];
    }
    
    function depositToContract() public payable{
        // this function deposits money to the smart contract
    }
    
    function sendMoneyFromContract(address payable _recv,uint _transf) public payable checkOwner checkMinimum(_transf) returns(bool){
        // this function allows to send money from contract to an address
        address payable receiver = _recv;
        uint amount = _transf;
        receiver.transfer(amount);
        //balance[address(this)]-=amount; 
        balance[receiver]+=amount;
        emit Pay(address(this),_recv,amount);
        return true;
    }
    
    function sendMoneyFromSender(address payable _recv,uint _transf) public payable checkOwner returns(bool){
        // this function allows to send money from a sender to address
        require(balance[msg.sender]>=_transf,"insufficient funds with sender");
        uint amount = _transf;
        balance[msg.sender]-=amount; 
        balance[_recv]+=amount;
        emit Pay(msg.sender,_recv,amount);
        return true;
    }
}