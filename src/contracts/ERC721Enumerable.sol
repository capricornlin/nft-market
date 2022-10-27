// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';



contract ERC721Enumerable is ERC721,IERC721Enumerable {

    uint[] private _allTokens;

    //mapping from tokenId to position in _allTokens array
    mapping(uint => uint) private _allTokenIndex;

    //mapping of owner to list of all owner token ids
    mapping(address => uint[]) private _ownedTokens;

    //mapping from tokenId to index of the owner tokens list
    mapping(uint => uint) private ownedTokensIndex;


   
    //NOTE: //just return how many token we have
    // function totalSupply() external view returns (uint256){ 
    //     return _allTokens.length; //mint越多，長度越長
    // }

    constructor(){
        //意思是要把supportsInterface轉換成unique ID
        _registerInterface(bytes4(keccak256('tokenByIndex(uint)')^keccak256('tokenOfOwnerByIndex(address,uint)')^keccak256('totalSupply()'))); 
        
    }

    //NOTE:this function will override ERC721 _mint() function
    //NOTE: 以後call _mint()時會執行這個
    function _mint(address to,uint tokenId) internal override(ERC721) {
        super._mint(to,tokenId);
        // 1. add tokens to owners
        // 2. all tokens to our totalsuppy - to all tokens

        _addTokensToAllTokenEnumeration(tokenId);
        _addTokenToOwnerEnumeration(to,tokenId);

    }

    function _addTokensToAllTokenEnumeration(uint tokenId) private {

        _allTokenIndex[tokenId] = _allTokens.length; // mapping tokenID 和 在_allTokens裡的index
        _allTokens.push(tokenId);  //tokenId加進_allTokens

    }

    function _addTokenToOwnerEnumeration(address to,uint tokenId) private {
        //1. add address and tokenId to the _ownedTokens
        //2. ownedTokenIndex tokenId set to address of ownedTokens position
        //3. we wnat to execute the function with minting
        ownedTokensIndex[tokenId] = _ownedTokens[to].length; //mapping "tokenId" to "owner token list index"
        _ownedTokens[to].push(tokenId); //mapping "owner address" to "owner's token list"

    }

    function tokenByIndex(uint index) public view returns(uint) {
        require(index < totalSupply(),'index is out of bounce!');
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner,uint index) public view returns(uint){
        require(index < balanceOf(owner),'index is out of bounce!');
        return _ownedTokens[owner][index];
    }

    function totalSupply() public view returns(uint) {
        return _allTokens.length;
    }



}