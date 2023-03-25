// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import { Seller, DetailStorage} from "./LibAssetData.sol";
import "../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../../lib/chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library LibAsset {
    event ItemListed(string ItemName, uint ItemPrice);

    event ItemPurchased(string ItemName, uint ItemPrice, address ItemContract);

function detailStorageSlot() internal pure returns(DetailStorage storage ds){
    assembly{
        ds.slot := 0
    }
}

    function _itemListed(
        string memory _itemName,
        uint _itemID,
        address _itemContract,
        uint _itemPrice
    ) internal {
        DetailStorage storage ds = detailStorageSlot();
        require(
            _itemContract != address(this),
            "You cant input this marketPlace contract Address"
        );
        require(
            IERC721(_itemContract).balanceOf(msg.sender) >= 1,
            "Your balance can not be zero "
        );
     

        IERC721(_itemContract).transferFrom(msg.sender, address(this), _itemID);
        ds.id++;
        Seller storage sId = ds.sellerId[ds.id];

        sId.ItemName = _itemName;
        sId.ItemID = _itemID;
        sId.ItemContract = _itemContract;
        sId.ItemPrice = _itemPrice;
        sId.ItemOwner = msg.sender;
        ds.idStatus[ds.id] = true;
        emit ItemListed(_itemName, _itemPrice);
    }

  

    function _buyItemListed(uint _id, uint tokenAmount) internal {
        AggregatorV3Interface priceFeed;
        DetailStorage storage ds = detailStorageSlot();

        address TokenCa = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

        priceFeed = AggregatorV3Interface(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );
        (
             /* uint80 roundID */,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/

        ) =
           priceFeed.latestRoundData();
        // uint price = 3;

        require(ds.idStatus[_id], "No item listed on this Id");

         Seller storage sId =  ds.sellerId[_id];
        uint priceItem = uint(price) /1e18;

       uint d = priceItem * sId.ItemID;
        require(tokenAmount >= d, "Insufficient value entered");
        require(IERC20(TokenCa).balanceOf(msg.sender) >= d, "Insuficient balance");
        IERC20(TokenCa).approve(address(this), tokenAmount);
        // IERC20(TokenCa).transfer( sId.ItemOwner, tokenAmount);
        IERC721(sId.ItemContract).transferFrom(address(this), msg.sender, sId.ItemID);

        emit ItemPurchased(sId.ItemName, tokenAmount, sId.ItemContract );
    }
}
