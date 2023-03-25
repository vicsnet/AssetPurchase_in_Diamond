// SPDX-License-Identifier: UNLICESED

pragma solidity ^0.8.0;
import "../contracts/facets/AssetFacet.sol";
import "./MockNFT.sol";
import "./deployDiamond.t.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract AssetFacetTest is DiamondDeployer {
    AssetFacet assetFacet;
    MockNFT mockNFT;
    address vince = vm.addr(0x1);
    address kenny = vm.addr(0x2);
    address usdcHolder = 0x60FaAe176336dAb62e284Fe19B885B095d29fB7F;
    

    function setUp() public {
        assetFacet = new AssetFacet();
        mockNFT = new MockNFT();
    }

    function mintAsset() public {
        mockNFT.mint();
    }

    function testAssetFacet() public {
        vm.startPrank(vince);

        mintAsset();
        mockNFT.approve(address(assetFacet), 0);
        assetFacet.listItemForSale("car", 0, address(mockNFT), 2);
       vm.stopPrank();
    }
function testBuyItemListed() public {
    testAssetFacet();
     vm.deal(usdcHolder, 10 ether);
    vm.startPrank(usdcHolder);
    IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).approve(address(assetFacet), 21840114973524208109322438 );
    assetFacet.buyItemListed(1, 21840114973524208109322438);
}
    
}
