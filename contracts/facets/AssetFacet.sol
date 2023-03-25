// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import {LibAsset} from "../libraries/LibAsset.sol";
contract AssetFacet{
        function listItemForSale(
        string memory _itemName,
        uint _itemID,
        address _itemContract,
        uint _itemPrice
    ) external {
        LibAsset._itemListed(_itemName, _itemID, _itemContract, _itemPrice);
        
    }

      function buyItemListed(uint _id, uint tokenAmount) external {
        LibAsset._buyItemListed(_id, tokenAmount);
    }
}