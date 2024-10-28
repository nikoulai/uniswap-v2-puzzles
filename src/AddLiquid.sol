// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";

import "./interfaces/IERC20.sol";

contract AddLiquid {
    /**
     *  ADD LIQUIDITY WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1000 USDC and 1 WETH.
     *  Mint a position (deposit liquidity) in the pool USDC/WETH to msg.sender.
     *  The challenge is to provide the same ratio as the pool then call the mint function in the pool contract.
     *
     */
    function addLiquidity(address usdc, address weth, address pool, uint256 usdcReserve, uint256 wethReserve) public {
        IUniswapV2Pair pair = IUniswapV2Pair(pool);

        // your code start here

        // see available functions here: https://github.com/Uniswap/v2-core/blob/master/contracts/interfaces/IUniswapV2Pair.sol

        uint256 usdcBalance = IERC20(usdc).balanceOf(address(this));
        uint256 wethBalance = IERC20(weth).balanceOf(address(this));

        uint256 usdcToLiquid = usdcBalance;
        uint256 wethToLiquid = wethBalance;
        // (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
        if (usdcReserve >= wethReserve) {
            // uint256 ratio = usdcReserve / wethReserve;

            // we will add all weth balance
            if (usdcBalance >= usdcReserve * wethBalance / wethReserve) {
                usdcToLiquid = usdcReserve * wethBalance / wethReserve;
            }
            // we will add all usdc balance
            else {
                wethToLiquid = wethBalance * wethReserve / usdcReserve;
            }
        } else {
            // uint256 ratio = wethReserve / usdcReserve;
            // we will add all weth
            if (wethBalance >= wethReserve * usdcBalance / usdcReserve) {
                wethToLiquid = wethReserve * usdcBalance / usdcReserve;
            } else {
                usdcToLiquid = wethBalance * usdcReserve / wethReserve;
            }
        }
        IERC20(usdc).transfer(pool, usdcToLiquid);
        IERC20(weth).transfer(pool, wethToLiquid);

        pair.mint(address(0xb0b));
    }
}
