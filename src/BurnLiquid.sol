// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

contract BurnLiquid {
    /**
     *  BURN LIQUIDITY WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 0.01 UNI-V2-LP tokens.
     *  Burn a position (remove liquidity) from USDC/ETH pool to this contract.
     *  The challenge is to use the `burn` function in the pool contract to remove all the liquidity from the pool.
     *
     */
    function burnLiquidity(address pool) public {
        /**
         *     burn(address to);
         *
         *     to: recipient address to receive tokenA and tokenB.
         */
        // your code here
        IUniswapV2Pair pair = IUniswapV2Pair(pool);
        uint256 decimals = pair.decimals();
        // Built-in binary operator * cannot be applied to types rational_const 1 / 100 and uint256. Fractional literals not supported.
        // Invalid type for argument in function call. Invalid implicit conversion from rational_const 1 / 100 to uint256 requested.
        // pair.transfer(pool, 0.01 * 10 ** decimals);

        uint256 balance = pair.balanceOf(address(this));

        pair.transfer(pool, balance);
        pair.burn(address(this));
    }
}
