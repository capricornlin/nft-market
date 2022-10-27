// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import './ERC165.sol';
import './interfaces/IERC721.sol';

contract ERC721 is ERC165,IERC721 {

    //it's just a log, not actually transfer anything
    // event Transfer(
    //         address indexed from,
    //         address indexed to,
    //         uint indexed tokenId
    //     );

    // event Approval(
    //     address indexed owner,
    //     address indexed approved,
    //     uint indexed tokenId
    // );

    //mapping from tokenId to owner
    mapping(uint => address) private _tokenOwner;  

    //mapping from owner to number of owned tokens
    mapping(address => uint) private _OwnedTokenCount;

    //mapping from tokenId to approved addresses
    mapping(uint => address) private _tokenApprovals;


     constructor(){
        //意思是要把supportsInterface轉換成unique ID
        _registerInterface(bytes4(keccak256('balanceOf(address)')^keccak256('ownerOf(uint)')^keccak256('transferFrom(address,address,uint)'))); 
    }


    
    function balanceOf(address _owner) public view returns(uint) {
        require(_owner != address(0),'owner query for non-existence token.');
        return _OwnedTokenCount[_owner];
    }


    
    function ownerOf(uint256 _tokenId) public view returns (address){
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0),'owner query for non-existence token.');
        return owner;
    }



    function _exists(uint tokenId) internal view returns(bool){
        address owner = _tokenOwner[tokenId];
        //如果owner已存在，這邊會回傳true
        return owner != address(0);
    }


    function _mint(address to,uint tokenId) internal virtual {
        require(to != address(0),'ERC721 : minting to the zero address');
        require(!_exists(tokenId),'token has already minted');
        _tokenOwner[tokenId] = to;
        _OwnedTokenCount[to] += 1;
        //from:應該是contract address，但方便起見我們用address(0)
        
        emit Transfer(address(0), to, tokenId);

    }

    
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0),'Error, ERC721 Transfer to the address(0)');
        require(ownerOf(_tokenId) == _from,'Error, Tyring to transfer token that address does not own.');
        _OwnedTokenCount[_from]-=1;
        _OwnedTokenCount[_to]+=1;
        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);

    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        require(isApprovedOrOwner(msg.sender,_tokenId));
        _transferFrom(_from,_to,_tokenId);
    }

    function approve(address _to,uint tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner,'Error, approval to current owner');
        require(msg.sender == owner,'Current caller is not the owner of the token');
        _tokenApprovals[tokenId] = _to;
        emit Approval(owner, _to, tokenId);
    }

    function isApprovedOrOwner(address spender, uint tokenId) internal view returns(bool){
        require(_exists(tokenId),'token does not exist.');
        address owner = ownerOf(tokenId);
        return (owner == spender ) ;
    }


}