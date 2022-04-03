//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Dex {

    mapping(string => uint) private _prices;

    function getPrice(string memory _ticker) external view returns(uint){
        return _prices[_ticker];
    }

    function buy(string memory _ticker, uint _amount, uint _price) external {

    }

    function sell(string memory _ticker, uint _amount, uint _price) external {
        
    }


}