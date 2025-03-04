// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IERC20.sol";

/**
 *
 *  ARBITRAGE A POOL
 *
 * Given two pools where the token pair represents the same underlying; WETH/USDC and WETH/USDT (the formal has the corect price, while the latter doesnt).
 * The challenge is to flash borrowing some USDC (>1000) from `flashLenderPool` to arbitrage the pool(s), then make profit by ensuring MyMevBot contract's USDC balance
 * is more than 0.
 *
 */
contract MyMevBot {
    address public immutable flashLenderPool;
    address public immutable weth;
    address public immutable usdc;
    address public immutable usdt;
    address public immutable router;
    bool public flashLoaned;

    constructor(address _flashLenderPool, address _weth, address _usdc, address _usdt, address _router) {
        flashLenderPool = _flashLenderPool;
        weth = _weth;
        usdc = _usdc;
        usdt = _usdt;
        router = _router;
    }

    function performArbitrage() public {
        // your code here

        // IUniswapV3Pool(flashLenderPool).flash(address(this), 10000 * 1e6, 1 * 1e18, "");
        IUniswapV3Pool(flashLenderPool).flash(address(this), 10000 * 1e6, 0, "");
    }

    function uniswapV3FlashCallback(uint256 _fee0, uint256, bytes calldata data) external {
        callMeCallMe();

        // your code start here

        address[] memory path = new address[](2);

        uint256 amountToSwap = IERC20(usdc).balanceOf(address(this));
        address;
        path[0] = usdc;
        path[1] = weth;

        IERC20(usdc).approve(router, amountToSwap);
        IUniswapV2Router(router).swapExactTokensForTokens(amountToSwap, 0, path, address(this), block.timestamp);

        uint256 wethBalance = IERC20(weth).balanceOf(address(this));
        path[0] = weth;
        path[1] = usdt;

        IERC20(weth).approve(router, wethBalance);
        IUniswapV2Router(router).swapExactTokensForTokens(wethBalance, 0, path, address(this), block.timestamp);

        uint256 usdtBalance = IERC20(usdt).balanceOf(address(this));
        path[0] = usdt;
        path[1] = usdc;

        IERC20(usdt).approve(router, usdtBalance);
        IUniswapV2Router(router).swapExactTokensForTokens(usdtBalance, 0, path, address(this), block.timestamp);

        uint256 profit = IERC20(usdc).balanceOf(address(this));

        uint256 amountOwed = amountToSwap + _fee0;
        require(profit >= amountOwed, "No profit made");
        IERC20(usdc).transfer(flashLenderPool, amountOwed);
        require(IERC20(usdc).balanceOf(address(this)) > 0, "Arbitrage failed");
    }

    function callMeCallMe() private {
        uint256 usdcBal = IERC20(usdc).balanceOf(address(this));
        require(msg.sender == address(flashLenderPool), "not callback");
        require(flashLoaned = usdcBal >= 1000 * 1e6, "FlashLoan less than 1,000 USDC.");
    }
}

interface IUniswapV3Pool {
    /**
     * recipient: the address which will receive the token0 and/or token1 amounts.
     * amount0: the amount of token0 to send.
     * amount1: the amount of token1 to send.
     * data: any data to be passed through to the callback.
     */
    function flash(address recipient, uint256 amount0, uint256 amount1, bytes calldata data) external;
}

interface IUniswapV2Router {
    /**
     *     amountIn: the amount to use for swap.
     *     amountOutMin: the minimum amount of output tokens that must be received for the transaction not to revert.
     *     path: an array of token addresses. In our case, WETH and USDC.
     *     to: recipient address to receive the liquidity tokens.
     *     deadline: timestamp after which the transaction will revert.
     */
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}
