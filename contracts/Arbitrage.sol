//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Dex} from "./Dex.sol";
import {Oracle} from "./Oracle.sol";

contract Arbitrage {

  address public admin;
  address private oracleAddress;

  struct Asset {
    string name;
    address addOfDex;
  }

  mapping(string => Asset) public assets;


  constructor() {
    admin = msg.sender;
  }

  function configureOracle(address _oracleAdd) external onlyAdmin() {
    oracleAddress = _oracleAdd;
    
  }

  function configureAssets(Asset[] memory _assets) external onlyAdmin() {
    for(uint i=0;i<_assets.length;i++){
      assets[_assets[i].name] = Asset(_assets[i].name, _assets[i].addOfDex);
    }
  }

  function timeForTrade(string memory _ticker, uint _timeOfTrade) external onlyAdmin() {
    Asset memory _asset = assets[_ticker];
    require(_asset.addOfDex != address(0), "This Asset does not exist");

    bytes32 dataKey = keccak256(abi.encodePacked(_ticker, _timeOfTrade));
    Oracle oracleContract = Oracle(oracleAddress);
    Oracle.Result memory result = oracleContract.getData(dataKey);

    require(result.exists == true, "This result does not exist, can not trade");

    Dex dexContract = Dex(_asset.addOfDex);
    uint price = dexContract.getPrice(_ticker);
    uint amount = 1 ether / price;

    if(price > result.payload) {
      dexContract.sell(_ticker, amount, (99* price/100));
    }else if (price < result.payload) {
      dexContract.buy(_ticker, amount, (101 * price/100));
    }
  }

  modifier onlyAdmin(){
    require(msg.sender == admin, "only admin");
    _;
  }


}