// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConvertor {
    function getPrice() internal view returns(uint256) {
        // ETH/USD
        // and address of contract that give us important info - 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e); // we call contract
        (,int answer,,,) = priceFeed.latestRoundData(); // and from contract we call latestRoundData, (,int answer,,,) - it's because function return muptiple variables but we need only answer(price)
        return uint256(answer * 10000000000); // because price from latestRoundData returns in 8 decimals when we need 18
    }

    function getConversionRate(uint256 amountEth) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethPriceToUsd = (ethPrice * amountEth) / 1000000000000000000; // we write / 1e18 because we want norma; decimals
        return ethPriceToUsd;
    }
}
