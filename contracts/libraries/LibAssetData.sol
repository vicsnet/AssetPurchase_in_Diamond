// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
// import "../../lib/chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";



struct DetailStorage{
uint id;
mapping(uint => Seller) sellerId;
mapping(uint => bool) idStatus;


}

struct Seller{
string ItemName;
uint ItemID;
address ItemContract;
uint ItemPrice;
address ItemOwner;

}
