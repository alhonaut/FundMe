// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConvertor.sol";

contract FundMe is Ownable {
    using PriceConvertor for uint256;

    uint256 public constant MINIMUM_USD_VALUE = 5000 * 1e18;

    address[] public funders;
    mapping(address => uint256) public amountToFunders;

    constructor() 
        Ownable(msg.sender)
    {}

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD_VALUE, "You don't have enough money"); // we have eth but we need convert to usdt
        funders.push(msg.sender); // we add investor to our list of funders
        amountToFunders[msg.sender] += msg.value; // we add investor to our lists of funders amount
    }


    function withdraw() public onlyOwner {
        // transfer if something wrong - return error
        uint256 balance = address(this).balance;
        //payable(msg.sender).transfer(balance);
        // send if something wrong - return bool (true or false)
        //bool succesSend = payable(msg.sender).send(balance);
        //require(succesSend, "Send is Failed");
        // call if something wrong - return bool (true or false) and return all gas or set gas *(recommended)*
        (bool succesCall, /*bytes dataReturned*/) = payable(msg.sender).call{value: balance}(""); // 'call' returned two variables
        require(succesCall, "Call is Failed");

        for (uint256 i = 0; i < funders.length; i++) {
            address temp_value = funders[i];
            amountToFunders[temp_value] = 0;
        }

        funders = new address[](0); // we reset array of funders and gave him lenght in o values

    }

    receive() external payable {
        fund(); // if somebody transfer money to contract without calling 'fund' we will call 'fund' for him
    }

    fallback() external payable {
        fund(); // if somebody transfer money to contract without calling 'fund' we will call 'fund' for him
    }
}
