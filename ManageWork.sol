pragma solidity ^0.5.0;

contract ManageWork {

    // owner is the owner of this smart contract
    address owner;
   
    struct Works{
       bytes32 workId;
       bytes32 title;
       bytes32 description;
       int amount;
       bytes32 status;
       bytes32 duration;
    }
    
    mapping (bytes32 => Works) works;
    
    constructor () internal {
        owner = msg.sender;
        
    }
    
    event WorkPosted(bytes32 workId, bytes32 title, bytes32 description, int amount, bytes32 status, bytes32 duration);
    event WorkInProgress(bytes32 workId, bytes32 title, bytes32 status);
    event WorkCompleted(bytes32 workId, bytes32 title, bytes32 status);
    event WorkTerminated(bytes32 workId, bytes32 title, bytes32 status);
    
    // initiate a work 
    function postWork(bytes32 workId, bytes32 title, bytes32 description, int amount, bytes32 status, bytes32 duration) public {
        Works storage work = works[workId];
        work.workId = workId;
        work.description = description;
        work.title = title;
        work.amount = amount;
        work.status = "Initialized";
        work.duration = duration;
        emit WorkPosted(workId, title, description, amount, status, duration);
    }
    
    // update work on each milestone completion
    function updateWork(bytes32 workId, bytes32 title, bytes32 status) public {
        Works storage work = works[workId];
        require(work.status != "Completed", "updateWork: Work Completed already.");
        if(work.status == "Initialized" && status == "In Progress"){
                work.status = status;
                emit WorkInProgress(workId, title, status);
        }else if(work.status == "In Progress" && status == "Completed"){
            work.status = status;
            emit WorkCompleted(workId, title, status);
        }else if(work.status == "In Progress"  && status == "Terminated"){
            work.status = status;
            emit WorkTerminated(workId, title, status);
        }
    }    
    
    //fetch work details by workId
    function getWorkByWorkId(bytes32 workId) public view returns (bytes32 work_id, bytes32 title, bytes32 description, int amount, bytes32 status, bytes32 duration) {
        return (works[workId].workId,works[workId].title,works[workId].description,works[workId].amount, works[workId].status, works[workId].duration);
    }
    
    
    
}