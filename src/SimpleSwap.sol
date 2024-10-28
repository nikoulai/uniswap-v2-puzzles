// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

import {console} from "forge-std/console.sol";

contract SimpleSwap {
    /**
     *  PERFORM A SIMPLE SWAP WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap any amount of WETH for USDC token using the `swap` function
     *  from USDC/WETH pool.
     *
     */
    function performSwap(address pool, address weth, address usdc) public {
        /**
         *     swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data);
         *
         *     amount0Out: the amount of USDC to receive from swap.
         *     amount1Out: the amount of WETH to receive from swap.
         *     to: recipient address to receive the USDC tokens.
         *     data: leave it empty.
         */

        // your code start here
        (uint256 usdcReserve, uint256 wethReserve,) = IUniswapV2Pair(pool).getReserves();

        uint256 wethAmount = IERC20(weth).balanceOf(address(this));

        console.log(wethAmount);
        console.log(usdcReserve);
        console.log(wethReserve);

        //calculate amount of USDC to receive from swap
        uint256 usdcAmountOut =
            usdcReserve - 1000 * (usdcReserve * wethReserve) / (1000 * wethReserve + wethAmount * 997);

        // console.log(usdcAmountOut);
        IERC20(weth).transfer(pool, wethAmount);
        //0.5% slippage
        IUniswapV2Pair(pool).swap(usdcAmountOut * 995 / 1000, 0, address(this), "");
    }
}
