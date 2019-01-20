pragma solidity ^ 0.5.1;


contract Escrow
{
    
    address payable public buyer;
    address payable public seller;
    address payable escrow_address;
    uint buyer_deposite;
    uint buyer_choice;
    uint seller_choice;
    
    
    // constructor
    constructor() public
    {  
        escrow_address = msg.sender;
        buyer =0xa83B8641AFCEDCbeB27c92D5546eF6aEeAAE6e29;
        seller = 0xCDdBb1BC1C13274Cc68BE77ca4a38F288f573843;
        buyer_choice = 0;
        seller_choice = 0;
    }

    function deposit() public payable
    {
        require(msg.value > 0 wei);
        buyer_deposite = msg.value;
    }
    
    function check_choice(bool choice) public returns (uint c)
    {
        if (choice){
            return 1;
        }
        else{
            return 2;
        }
        
    }
    
    function transfer(bool choice) public payable
    {
        if (msg.sender == buyer){
           buyer_choice = check_choice(choice); 
        }
        else if (msg.sender == seller){
            seller_choice = check_choice(choice); 
        }
        if (buyer_choice == 1 && seller_choice == 1){
           trasaction_completed();
        }
        else if (buyer_choice == 2 || seller_choice == 2){
            transaction_cancel();
        }
    }
    
    function trasaction_completed() public
    {
        escrow_address.transfer(address(this).balance/100);
        seller.transfer(address(this).balance);
        buyer_deposite = 0;
        buyer_choice = 0;
        seller_choice = 0;
    }
    
    function transaction_cancel() public
    {
        escrow_address.transfer(address(this).balance/100);
        buyer.transfer(address(this).balance);
        buyer_deposite = 0;
        buyer_choice = 0;
        seller_choice = 0;
    }
    
    function timeout_trasaction() public
    {
        if (buyer_choice == 1 && seller_choice == 0){
            kill_function();
        }
        else if (seller_choice == 1 && buyer_choice == 0) {
            escrow_address.transfer(address(this).balance/100);
            buyer.transfer(address(this).balance);
        }
    }
    
    function kill_function() public 
    {
        escrow_address.transfer(address(this).balance/100);
        buyer.transfer(address(this).balance);
    }
    
}