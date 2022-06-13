// SPDX-License-Identifier: MIT

// Distributed Ledger Technlogy enables decentralisation. Fractionalised NFTs enables part ownership.
// Ownership has the benefits of connection and responsibility, plus more.
// Own parts of everything, (through) fractionalised NFTs, and be happy 

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Base64.sol";

contract NFT is ERC721Enumerable, Ownable {
  using Strings for uint256;

  constructor() ERC721("Own Everything Be Happy", "OEBH") {}

  // public
  function mint() public payable {
    uint256 supply = totalSupply();
    require(supply + 1 <= 256);  //10000 is maxSupply

    if (msg.sender != owner()) {
      require(msg.value >= 0.005 ether);
    } 

      _safeMint(msg.sender, supply + 1);
  }

  function buildImage() public pure returns(string memory) {
    return Base64.encode(bytes(abi.encodePacked(
      "<svg width='1024' height='480' xmlns='http://www.w3.org/2000/svg' xmlns:svg='http://www.w3.org/2000/svg'>",
      "<defs><style type='text/css'>@import url('https://fonts.googleapis.com/css?family=Titan+One');</style></defs>",
      "<text line-height='1.5' style='font-weight:bold;font-size:64px;fill:#00ffff;stroke:#000000;stroke-width:0.2'>",
      "<tspan style='fill:#ffffff' text-anchor='end' x='41%' y='35%'>You'll own</tspan>",
      "<tspan style='fill:#ffffff' text-anchor='end' x='41%' y='49%'>And you'll</tspan>",
      "<tspan x='41%' y='35%'>everything.</tspan>",
      "<tspan x='41%' y='49%'>be happy</tspan>",
      "<tspan style='font-size:24px;' x='41.2%' y='22%'>parts of</tspan>",
      "<tspan style='font-size:24px;' x='41.2%' y='58.5%'>fractionalized NFTs</tspan></text></svg>"
    )));
  }

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );

    return string(abi.encodePacked(
      'data:application/json;base64,', Base64.encode(bytes(abi.encodePacked(
        '{"name":"',
        "REPLACE",
        '", "description":"',
        "REPLACE",
        '", "image": "',
        'data:image/svg+xml;base64,',
        buildImage(),
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