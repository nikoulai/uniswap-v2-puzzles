// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {SimpleSwap} from "../src/SimpleSwap.sol";
import "../src/interfaces/IUniswapV2Pair.sol";

contract SimpleSwapTest is Test {
    SimpleSwap public simpleSwap;
    address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public pool = 0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc;

    function setUp() public {
        simpleSwap = new SimpleSwap(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        // transfers 1 ETH to simpleSwap contract
        vm.deal(address(simpleSwap), 1 ether);
    }

    function test_PerformSwap() public {
        address[] memory path = new address[](2);
        path[0] = weth;
        path[1] = usdc;

        vm.prank(address(0xb0b));
        simpleSwap.performSwap(path);

        uint256 puzzleBal = IUniswapV2Pair(usdc).balanceOf(address(simpleSwap));
        require(puzzleBal > 0);
    }
}
