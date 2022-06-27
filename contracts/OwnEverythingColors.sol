// SPDX-License-Identifier: MIT

// Distributed Ledger Technlogy enables decentralisation. Fractionalised NFTs enables part ownership.
// Ownership has the benefits of connection and responsibility, plus more.
// Own parts of everything, (through) fractionalised NFTs, and be happy 

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Base64.sol";

contract NFT is ERC721Enumerable, Ownable {
  using Strings for uint256;

  string[] public fontValues = ["Sarina","Gorditas","Chewy","Kavoon","Shrikhand","Knewave","Chicle","Ranchers","Coiny","Slackey"];
  
   struct Word { 
      string name;
      string textHue;
      string value;
   }
  
  mapping (uint256 => Word) public words;

  constructor() ERC721("Own Everything Be Happy", "OEBH") {}

  // public
  function mint() public payable {
    uint256 supply = totalSupply();
    require(supply + 1 <= 256);  //10000 is maxSupply

    Word memory newWord = Word(
      string(abi.encodePacked('OWN #', uint256(supply + 1).toString())), 
      randomNum(361, block.difficulty, supply).toString(),
      fontValues[randomNum(fontValues.length, block.difficulty, supply)]);

    if (msg.sender != owner()) {
      require(msg.value >= 0.005 ether);
    } 

    words[supply + 1] = newWord;
    _safeMint(msg.sender, supply + 1);
  }

  function randomNum(uint256 _mod, uint256 _seed, uint _salt) public view returns(uint256) {
      uint256 num = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _seed, _salt))) % _mod;
      return num;
  }

  function buildImage(uint256 _tokenId) public view returns(string memory) {
    Word memory currentWord = words[_tokenId];
    return Base64.encode(bytes(abi.encodePacked(
      "<svg width='1024' height='480' xmlns='http://www.w3.org/2000/svg' xmlns:svg='http://www.w3.org/2000/svg'>",
      "<defs><style type='text/css'>@import url('https://fonts.googleapis.com/css?family=",currentWord.value,"');</style></defs>",
      "<text style='font-weight:bold;font-size:64px;fill:",currentWord.textHue,";stroke:#000000;stroke-width:0.2;font-family:",currentWord.value,"'>",
      "<tspan style='fill:#ffffff' text-anchor='end' x='41%' y='35%'>You'll own</tspan>",
      "<tspan style='fill:#ffffff' text-anchor='end' x='41%' y='49%'>And you'll</tspan>",
      "<tspan x='42%' y='35%'>everything.</tspan>",
      "<tspan x='42%' y='49%'>be happy</tspan>",
      "<tspan style='font-size:24px;' x='42.4%' y='22%'>parts of</tspan>",
      "<tspan style='font-size:24px;' x='42.4%' y='58.5%'>fractionalized NFTs</tspan></text></svg>"
    )));
  }

  function tokenURI(uint256 _tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(_tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );

    Word memory currentWord = words[_tokenId];
    return string(abi.encodePacked(
      'data:application/json;base64,', Base64.encode(bytes(abi.encodePacked(
        '{"name":"',
        currentWord.name,
        '", "description":"',
        "Decentralisation - no need for a central body owning things and you are renting them. Fractionised NFTs - you can own parts of a thing and reap the rewards of ownership",
        '", "image": "',
        'data:image/svg+xml;base64,',
        buildImage(_tokenId),
        '"}'
      )))));
  }

  //only owner
 
  function withdraw() public payable onlyOwner {
    // This will pay HashLips 5% of the initial sale.
    // You can remove this if you want, or keep it in to support HashLips and his channel.
    // =============================================================================
    (bool hs, ) = payable(0x943590A42C27D08e3744202c4Ae5eD55c2dE240D).call{value: address(this).balance * 5 / 100}("");
    require(hs);
    // =============================================================================
    
    // This will payout the owner 95% of the contract balance.
    // Do not remove this otherwise you will not be able to withdraw the funds.
    // =============================================================================
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
    // =============================================================================
  }
}