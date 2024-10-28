// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";

contract Twap {
    /**
     *  PERFORM A ONE-HOUR AND ONE-DAY TWAP
     *
     *  This contract includes four functions that are called at different intervals: the first two functions are 1 hour apart,
     *  while the last two are 1 day apart.
     *
     *  The challenge is to calculate the one-hour and one-day TWAP (Time-Weighted Average Price) of the first token in the
     *  given pool and store the results in the return variable.
     *
     *  Hint: For each time interval, the player needs to take a snapshot in the first function, then calculate the TWAP
     *  in the second function and divide it by the appropriate time interval.
     *
     */
    IUniswapV2Pair pool;

    // 1HourTWAP storage slots
    uint256 public first1HourSnapShot_Price0Cumulative;
    uint32 public first1HourSnapShot_TimeStamp;
    uint256 public second1HourSnapShot_Price0Cumulative;
    uint32 public second1HourSnapShot_TimeStamp;

    // 1DayTWAP storage slots
    uint256 public first1DaySnapShot_Price0Cumulative;
    uint32 public first1DaySnapShot_TimeStamp;
    uint256 public second1DaySnapShot_Price0Cumulative;
    uint32 public second1DaySnapShot_TimeStamp;

    constructor(address _pool) {
        pool = IUniswapV2Pair(_pool);
    }

    //**       ONE HOUR TWAP START      **//
    function first1HourSnapShot() public {
        // your code here

        // first1HourSnapShot_TimeStamp = uint32(block.timestamp % 2 ** 32);
        (,, first1HourSnapShot_TimeStamp) = pool.getReserves();
        first1DaySnapShot_Price0Cumulative = pool.price0CumulativeLast();
    }

    function second1HourSnapShot() public returns (uint224 oneHourTwap) {
        // your code here

        (,, second1HourSnapShot_TimeStamp) = pool.getReserves();
        second1DaySnapShot_Price0Cumulative = pool.price0CumulativeLast();

        uint32 denominator;
        unchecked {
            denominator = second1HourSnapShot_TimeStamp - first1HourSnapShot_TimeStamp;
        }
        // oneHourTwap = (second1HourSnapShot_Price0Cumulative - first1HourSnapShot_Price0Cumulative)
        //     / (second1HourSnapShot_TimeStamp - first1HourSnapShot_TimeStamp);
        // second1HourSnapShot_TimeStamp = uint32(block.timestamp % 2 ** 32);
        unchecked {
            oneHourTwap =
                uint224((second1HourSnapShot_Price0Cumulative - first1HourSnapShot_Price0Cumulative) / denominator);
        }

        return oneHourTwap;
    }
    //**       ONE HOUR TWAP END      **//

    //**       ONE DAY TWAP START      **//
    function first1DaySnapShot() public {
        // your code here

        // first1DaySnapShot_TimeStamp = uint32(block.timestamp % 2 ** 32);
        (,, first1DaySnapShot_TimeStamp) = pool.getReserves();
        first1DaySnapShot_Price0Cumulative = pool.price0CumulativeLast();
    }

    function second1DaySnapShot() public returns (uint224 oneDayTwap) {
        // your code here

        second1DaySnapShot_TimeStamp = uint32(block.timestamp % 2 ** 32);
        second1DaySnapShot_Price0Cumulative = pool.price0CumulativeLast();

        oneDayTwap = uint224(
            (second1DaySnapShot_Price0Cumulative - first1DaySnapShot_Price0Cumulative)
                / (second1DaySnapShot_TimeStamp - first1DaySnapShot_TimeStamp)
        );
        return (oneDayTwap);
    }
    //**       ONE DAY TWAP END      **//

    function getTimeElapsed(uint32 lastSnapshotTime) internal view returns (uint32 t) {
        unchecked {
            t = uint32(block.timestamp % 2 ** 32) - lastSnapshotTime;
        }
    }
}
