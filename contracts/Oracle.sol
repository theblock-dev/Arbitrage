//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Oracle {

    struct Result {
        bool exists;
        uint payload;
        address[] approvedBy;
    }

    mapping(bytes32 => Result) private _results;
    address[] private _validators;

    constructor(address[] memory _listOfValidators) {
        _validators = _listOfValidators;
    }

    function feedData(bytes32 _dataKey, uint _payload) external onlyValidator() {
        address[] memory _approvedBy = new address[](1);
        _approvedBy[0] = msg.sender;
        require(_results[_dataKey].exists == false, "This data was already imported");
        _results[_dataKey] = Result(true, _payload, _approvedBy);
    }

    function getData(bytes32 _dataKey) external view returns(Result memory){
        return _results[_dataKey];
    }

    modifier onlyValidator() {
        bool isValidator = false;
        for(uint i=0;i<_validators.length;i++){
            if(_validators[i] == msg.sender){
                isValidator = true;
                break;
            }
        }
        require(isValidator == true, "Only Validator");
        _;
    }

}