// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.13;

contract LotteryGame{

    // address is the public key of participant on blockchain
    address [] participants;
    address payable winner;
    address owner;
    bool state;
    uint balance;
    mapping (address => uint) public contributions;

    constructor(){
        state = true;
        owner = msg.sender;
    }

    function getBal() public view returns (uint){ 
        return balance;
    }

    function getstate() public view returns (bool){
        return state;
    }

    function getwinner() public view returns (address){
        return winner;
    }

    function getowner() public view returns (address){
        return owner;
    }

    function getParticipants() public view returns (address [] memory){
        return participants;
    }

    // function getAmt(address addr) public view returns (uint){
    //     return contributions[addr];
    // }

    function getRandomNum() private view returns (uint){
        uint num = 0;
        num = uint(keccak256(abi.encodePacked(state, owner, block.timestamp)));
        return num;
    }

    function select_winner() owneronly public {
        uint index = getRandomNum()%participants.length;
        winner = payable(participants[index]);
    }

    function send_prize() owneronly public {
        require(winner!=address(0), "There is no winner yet");
        winner.transfer(address(this).balance);
        balance = 0;
    }

    function participate() public payable {
        require(msg.value >= 10 wei, "Minimum contribution required is 10 wei");
        address user = msg.sender;
        participants.push(user);
        contributions[user] = uint(msg.value);
        balance = balance + uint(msg.value);

    }

    function reset_all() public {
        require (balance == 0, "Balance is available in game account. Reset is not possible.");
        state = false;
        delete participants;
        delete winner; 
        delete owner;
    }

    modifier owneronly(){
        require(msg.sender == owner, "You are not the owner.");
        _;}

}