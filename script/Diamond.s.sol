// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../contracts/Diamond.sol";
import "../contracts/facets/DiamondCutFacet.sol";
import "../contracts/facets/DiamondLoupeFacet.sol";
import "../contracts/facets/OwnershipFacet.sol";
import "../contracts/interfaces/IDiamondCut.sol";
import "../contracts/facets/AssetFacet.sol";

import "../lib/forge-std/src/Script.sol";

contract DiamondScript is Script, IDiamondCut{

    function run() external{
        Diamond diamond;
        DiamondCutFacet dCutFacet;
        DiamondLoupeFacet dLoupe;
        OwnershipFacet ownerF;
        AssetFacet assetF;
        address deployer = 0x8DCeC3aF87Efc4B258f2BCAEB116D36B9ca012ee;
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        

        dCutFacet = new DiamondCutFacet();
        diamond = new Diamond(deployer, address(dCutFacet));
        dLoupe = new DiamondLoupeFacet();
        ownerF = new OwnershipFacet();
        assetF = new AssetFacet();

        FacetCut[] memory cut = new FacetCut[](3);
        
        cut[0] =(
            FacetCut({
                facetAddress: address(dLoupe),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("DiamondLoupeFacet")
            })
        );
        cut[1] =(
            FacetCut({
                facetAddress: address(ownerF),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("OwnershipFacet")
            })
        );
        cut[2] =(
            FacetCut({
                facetAddress: address(assetF),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("AssetFacet")
            })
        );

        IDiamondCut(address(diamond)).diamondCut(cut, address(0x0), "");

        // call a function
        DiamondLoupeFacet(address(diamond)).facetAddresses();
        vm.stopBroadcast();
        

    }
// Diamond CA:0x3cBFFB0520D908d8947b6036Aeb5Ac0D08e0D8Df
     function generateSelectors(string memory _facetName)
        internal
        returns (bytes4[] memory selectors)
    {
        string[] memory cmd = new string[](3);
        cmd[0] = "node";
        cmd[1] = "scripts/genSelectors.js";
        cmd[2] = _facetName;
        bytes memory res = vm.ffi(cmd);
        selectors = abi.decode(res, (bytes4[]));
    }

    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external override {}
}