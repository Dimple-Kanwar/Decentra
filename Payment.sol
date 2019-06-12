pragma solidity ^0.5.0;

contract Payment {
   
    // owner is the owner of this smart contract
    address owner;
    
    event paymentClearedByMilestone(int milestone,bytes32 paymentId,address payer,address payee,int amount,bytes32 status,int clearedAmount);
    event paymentCleared(int milestone,bytes32 paymentId,address payer,address payee,int amount,bytes32 status,int clearedAmount);

    // payment data structure
    struct Payments {
        bytes32 paymentId;
        address payee;
        address payer;
        int amount;
        int penaltyAmount;
        bytes32 status;
        int clearedAmount;
    }
    
    mapping (bytes32 => Payments) payments;
    
    constructor () internal {
        owner = msg.sender;
        
    }
    
    // initiate a payment 
    function initiatePayment(bytes32 paymentId, address payer, address payee, int amount, int penaltyAmount) public {
        Payments storage payment = payments[paymentId];
        payment.payee = payee;
        payment.payer = payer;
        payment.amount = amount;
        payment.penaltyAmount = penaltyAmount;
        payment.status = "Initialized";
    }
    
    // update payment on each milestone completion
    function clearPaymentBymilestone(int milestone, bytes32 paymentId, address payer, address payee, int amount, bytes32 status) public {
        Payments storage payment = payments[paymentId];
        require(payment.status != "Cleared", "clearPaymentBymilestone: full payment already cleared");
        payment.clearedAmount = (milestone/5)*amount;
        payment.status = status;
        if(milestone == 5) {
            emit paymentCleared(milestone,paymentId,payer,payee,amount,payment.status,payment.clearedAmount);
        } else {
            emit paymentClearedByMilestone(milestone,paymentId,payer,payee,amount,payment.status,payment.clearedAmount);
        }
    }    
    
    //fetch payment details by paymentId
    function getPaymentByPaymentId(bytes32 paymentId) public view returns (address payee, address payer, int amount, int penaltyAmount,bytes32 status) {
        return (payments[paymentId].payee,payments[paymentId].payer,payments[paymentId].amount,payments[paymentId].penaltyAmount, payments[paymentId].status);
    }
    
    
    
}