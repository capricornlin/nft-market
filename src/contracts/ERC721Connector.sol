// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Metadata.sol';
//import './ERC721.sol';
import './ERC721Enumerable.sol';  //NOTE:ERC721已經被它繼承了

contract ERC721Connector is ERC721Metadata,ERC721Enumerable {

    //繼承ERC721Metadata 
    constructor(string memory name,string memory symbol) ERC721Metadata(name,symbol){

    } 
}
