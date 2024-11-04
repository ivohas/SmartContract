// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract Admin {

    address public admin;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin(){
        require(msg.sender == admin, "Only admin can do this!");
        _;
    }

    function changeAdmin(address newAdmin) public onlyAdmin {

        require (newAdmin != address(0), "Invalid address!");
        admin = newAdmin;
    }
}