//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import { Base64 } from "./Libraries/Base64.sol";
import "hardhat/console.sol";

contract NFTLottery is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private tokenIds;
    constructor() ERC721("TEAMMATIC", "MATIC") {} 

    string[] firstwords = ["Bread", "Cheese", "Basil", "Rice", "Spaghetti", "Noodles", "Beans", "Pizza", "Icecream", "Chicken", "Nuggets", "Potatoes", "Prawn", "Purkey", "Burger", "Hotdog", "Syrup", "Waffles", "Pancakes", "Crepes"];
    string[] secondwords = ["Dance", "Swim", "Cook", "Jump", "Make", "Cry", "Smile", "Laugh", "Sick", "Important", "Worried", "love", "busy", "school", "electrons", "photons", "maple", "candles", "cane", "grow"];
    string[] thirdwords = ["goat", "lion", "tiger", "tortoise", "spider", "bat", "cat", "dog", "alligator", "crocodile", "squirrel", "slug", "snail", "koala", "bear", "bison", "giraffe", "dear", "elephant", "horse"];
    
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: pink; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    function makeFirstWord(uint tokenId) public view returns(string memory) {
        uint rand = uint(keccak256(abi.encodePacked("FIRSTwords", Strings.toString(tokenId))));
        rand = rand%firstwords.length;
        return firstwords[rand];
    }
    
    function makeSecondWord(uint tokenId) public view returns(string memory) {
        uint rand = uint(keccak256(abi.encodePacked("SECONDwords", Strings.toString(tokenId))));
        rand = rand%secondwords.length;
        return secondwords[rand];
    }

    function makeThirdWord(uint tokenId) public view returns(string memory) {
        uint rand = uint(keccak256(abi.encodePacked("THIRDwords", Strings.toString(tokenId))));
        rand = rand%thirdwords.length;
        return thirdwords[rand];
    }
    
    function mintAnNFT() public {
        uint256 newItemID = tokenIds.current();

        string memory first = makeFirstWord(newItemID);
        string memory second = makeSecondWord(newItemID);
        string memory third = makeThirdWord(newItemID);
        string memory finalSvg = string(abi.encodePacked(baseSvg,first,second,third, "</text></svg>"));
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "', 
                          combinedWord,
                          '", "description": "Team Matic NFT lottery collection", "image" : "data:image/svg+xml;base64,',
                          Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        _safeMint(msg.sender, newItemID);
        _setTokenURI(newItemID, finalTokenUri);
        tokenIds.increment();
        console.log(finalSvg);
    }
}