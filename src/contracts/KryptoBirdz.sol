// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';


contract KryptoBirdz is ERC721Connector {

    string[] public kryptoBirdz;
    mapping (string => bool) _KryptoBirdzExists;

    //繼承ERC721Connector
    constructor() ERC721Connector('KryptoBird','KBIRDZ'){ 
        
    }

    function mint(string memory _kryptoBird) public {
        require(!_KryptoBirdzExists[_kryptoBird],'Error - KryptoBird has already exists!!');

        //this is deprecated, .push don't return the length anymore
        //uint _id = KryptoBirdz.push(_kryptoBird);

        kryptoBirdz.push(_kryptoBird);
        uint _id = kryptoBirdz.length -1;

        //msg.sender就是部署這個contract的人，所以msg.sender = Ganache提供的address
        _mint(msg.sender,_id);
        _KryptoBirdzExists[_kryptoBird] = true;


    }
}
