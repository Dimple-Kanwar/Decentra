pragma solidity ^0.5.0;

/**
 * @dev A Accounts contract can only be used by users to manage their accounts.
 */
contract Accounts {
   
    // owner is the owner of this smart contract
    address owner;
    
    // user account data
    struct User {
        bytes32 username;
        address account;
        bytes32 role;
        int balance;
    }
    
    mapping (address => User) users;
    
    constructor () public {
        owner = msg.sender;
    }
    
    event accountAdded(bytes32 username, address account, bytes32 role, int balance);
    event accountUpdated(address account, int balance);
    
    // enroll user account in the network
    function addAccount(bytes32 username, bytes32 role, int balance) public {
        User storage user = users[msg.sender];

        user.username = username;
        user.account = msg.sender;
        user.role = role;
        user.balance = balance;
        
        emit accountAdded(user.username, user.account, user.role, user.balance);
    }
    
    // update balance of a user account
    function updateAccount(int balance) public {
        User storage user = users[msg.sender];
        user.balance = balance;
        emit accountUpdated(msg.sender, user.balance);
    }    
    
    //fetch account details by account address
    function getAccountByAddress() public view returns(bytes32 username, address account, bytes32 role, int balance){
        return (users[msg.sender].username,users[msg.sender].account,users[msg.sender].role,users[msg.sender].balance);
    }
    
    
}