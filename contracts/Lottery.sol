// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Lottery {
     address public admin;
    address payable[] public players;
    uint public lotteryId;
    mapping (uint => address payable) public lotteryHistory;

    constructor(){
      admin = msg.sender;
    }

    modifier onlyAdmin(){
      require(msg.sender == admin,'Only the admin can access this');
      _;
    }

    modifier adminsCantParticipate(){
      require(msg.sender != admin,'Admin cannot participate');
        require(msg.value !=1 ether,'You have to pay .01 ether to participate');
      _;
    }

    function getBalance() public view returns (uint){
      return address(this).balance;
    }

    function getNumberOfPlayers() public view returns(address payable[] memory){
      return players;
    }

      function random() public view returns (uint){
        return uint(keccak256(abi.encodePacked(admin,block.timestamp)));
    }

       function participate() public payable adminsCantParticipate{ 
        players.push(payable(msg.sender));  
    }

    function pickWinner() public onlyAdmin{
        uint index = random() % players.length;
        players[index].transfer(address(this).balance);
        lotteryId++;
        lotteryHistory[lotteryId] = players[index];
        players = new address payable[](0);
    }

     function getLotteryWinner(uint _lotteryId) public view returns(address payable){
        return lotteryHistory[_lotteryId];
    }





}