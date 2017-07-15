pragma solidity ^0.4.10;

contract Random {
    /* Generates a random number from 0 to max based on the last block hash */
    function randomGen(uint max) constant returns (uint randomNumber) {
        return(uint(sha3(block.blockhash(block.number-1))) % max);
    }
}