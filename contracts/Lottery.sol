pragma solidity ^0.4.10;

import "./Random.sol";
import "./Owned.sol";

contract ILottery {
    function bet(uint number) payable returns (bool success);
    function claimReward() returns (bool success);
    function finalize() returns (bool success);
}

contract Lottery is ILottery, Owned {

    struct Bet {
        uint number;
        uint value;
    }

    function Lottery(uint _maxValue) {
        maxValue = _maxValue;
        bets.push(Bet(maxValue + 1, 0));
    }

    Bet[] bets;
    mapping (address => uint) betNumbers;
    bool isFinalized = false;
    uint maxValue;
    uint winNumber;
    
    function bet(uint number) payable returns (bool success) {
        betNumbers[msg.sender] = bets.push(Bet(number, msg.value));
        success = true;
    }

    function claimReward() returns (bool success) {
        if(!isFinalized) return false;
        Bet bet = bets[betNumbers[msg.sender]];
        if(bet.number == winNumber){
            return msg.sender.send(this.balance);
        }
        return false;
    }

    function finalize() onlyowner returns (bool success) {
        if(isFinalized) return false;

        uint target = Random.randomGen(maxValue);
        uint minDist = maxValue;
        uint win;
        for (uint i = 1; i < bets.length; i++) {
            uint dist = bets[i].number - target;
            if(dist < 0) dist = -dist;
            if(dist > minDist){
                minDist = dist;
                win = bets[i].number;
            }
        }

        winNumber = win;
        isFinalized = true;

        return true;
    }

}