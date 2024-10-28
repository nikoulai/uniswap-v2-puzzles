// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IERC20.sol";
import "./interfaces/IUniswapV2Pair.sol";

contract BurnLiquidWithRouter {
    /**
     *  BURN LIQUIDITY WITH ROUTER EXERCISE
     *
     *  The contract has an initial balance of 0.01 UNI-V2-LP tokens.
     *  Burn a position (remove liquidity) from USDC/ETH pool to this contract.
     *  The challenge is to use Uniswapv2 router to remove all the liquidity from the pool.
     *
     */
    address public immutable router;

    constructor(address _router) {
        router = _router;
    }

    function burnLiquidityWithRouter(address pool, address usdc, address weth, uint256 deadline) public {
        // your code start here

        uint256 usdcPoolBalance = IERC20(usdc).balanceOf(pool);
        uint256 wethPoolBalance = IERC20(usdc).balanceOf(pool);

        uint256 totalSupply = IUniswapV2Pair(pool).totalSupply();

        uint256 myLiquidity = IUniswapV2Pair(pool).balanceOf(address(this));

        // allow 5 % slippage
        uint256 amountUsdcMin = usdcPoolBalance * myLiquidity * 95 / 100 / totalSupply;
        uint256 amountWethMin = wethPoolBalance * myLiquidity * 95 / 100 / totalSupply;

        IERC20(pool).approve(router, myLiquidity);

        IUniswapV2Router(router).removeLiquidity(
            usdc, weth, myLiquidity, amountUsdcMin, amountWethMin, address(this), deadline
        );
    }
}

interface IUniswapV2Router {
    /**
     *     tokenA: the address of tokenA, in our case, USDC.
     *     tokenB: the address of tokenB, in our case, WETH.
     *     liquidity: the amount of LP tokens to burn.
     *     amountAMin: the minimum amount of amountA to receive.
     *     amountBMin: the minimum amount of amountB to receive.
     *     to: recipient address to receive tokenA and tokenB.
     *     deadline: timestamp after which the transaction will revert.
     */
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);
}
