// SPDX-License-Identifier: MIT
// Distributed Ledger Technlogy enables decentralisation. Fractionalised NFTs enables part ownership.
// Ownership has the benefits of connection and responsibility, plus more.
// Own parts of everything, (through) fractionalised NFTs, and be happy 

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Base64.sol";

contract OwnEverything is ERC721Enumerable, Ownable {
  using Strings for uint256;

  constructor() ERC721("Own Everything", "OCN") {}

  // public
  function mint() public payable {
    uint256 supply = totalSupply();
    require(supply + 1 <= 1);

    if (msg.sender != owner()) {
      require(msg.value >= 0.005 ether);
    }

      _safeMint(msg.sender, supply + 1);
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
      'data:application/json;base64,', Base64.encode(abi.encodePacked(bytes(abi.encodePacked(
        '{"name":"',
        "Own Everything",
        '", "description":"',
        "Fractionalisation represents decentralisation",
        '", "image": "',
        'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNTEyIiBoZWlnaHQ9IjUxMiIgdmlld0JveD0iMCAwIDEzNS40NjY2NiAxMzUuNDY2NjciIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6c3ZnPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiA8dGV4dCB0cmFuc2Zvcm09Im1hdHJpeCgwLjc2MjA3NTc0LDAsMCwxLjI2OTc5MDQsLTIxNi41Mjc1NCwtNDMzLjg4Nzk4KSIKICAgICAgIHN0eWxlPSJmb250LXN0eWxlOm5vcm1hbDtmb250LXZhcmlhbnQ6bm9ybWFsO2ZvbnQtd2VpZ2h0Om5vcm1hbDtmb250LXN0cmV0Y2g6bm9ybWFsO2ZvbnQtc2l6ZToxMC42NjY3cHg7bGluZS1oZWlnaHQ6MC45O2ZvbnQtZmFtaWx5OlRhaG9tYTt0ZXh0LWFsaWduOmNlbnRlcjt3aGl0ZS1zcGFjZTpwcmU7c2hhcGUtaW5zaWRlOnVybCgjcmVjdDM1Nyk7ZGlzcGxheTppbmxpbmU7ZmlsbDojMDAwMDAwIj48dHNwYW4KICAgICAgICAgeD0iMzM2Ljk3MjM5IgogICAgICAgICB5PSI0MDcuMDAzNTUiCiAgICAgICAgID48dHNwYW4KICAgc3R5bGU9ImZvbnQtc2l6ZTo3LjA4MTA5cHgiCiAgID5GUkFDVElPTkFMSVpFRCBORlRzPC90c3Bhbj4KPC90c3Bhbj48dHNwYW4KICAgICAgICAgeD0iMjkzLjkwOTA4IgogICAgICAgICB5PSI0MzkuMzYwMDQiCiAgICAgICAgID48dHNwYW4KICAgc3R5bGU9ImZvbnQtd2VpZ2h0OmJvbGQ7IgogICA+QkU8L3RzcGFuPiA8dHNwYW4KICAgc3R5bGU9ImZvbnQtd2VpZ2h0OmJvbGQ7Zm9udC1zaXplOjQxLjUzcHg7IgogICA+SEFQUFk8L3RzcGFuPjwvdHNwYW4+PC90ZXh0PgogICAgPHRleHQKICAgICAgIHN0eWxlPSJmb250LWZhbWlseTpUYWhvbWE7Zm9udC1zaXplOjQuODc1OThweDt0ZXh0LWFuY2hvcjptaWRkbGUiCiAgICAgICB4PSIxMy43MDc1NDQiCiAgICAgICB5PSIxMDkuNDU1NjQiCiAgICAgICB0cmFuc2Zvcm09InNjYWxlKDAuOTc2MTMyMSwxLjAyNDQ1MTUpIj48dHNwYW4KICAgICAgICAgeD0iMTMuNzA3NTQ0IgogICAgICAgICB5PSIxMDkuNDU1NjQiPkFORDwvdHNwYW4+PC90ZXh0PgogICAgPHRleHQKICAgICAgIHRyYW5zZm9ybT0ibWF0cml4KDAuNTA5OTU4NjgsMCwwLDAuNzAxNjI5MzUsLTE2My4zNTAzMiwtMTAwLjA4NjYpIgogICAgICAgPjx0c3BhbgogICAgICAgICB4PSIzMzQuMjAxNCIKICAgICAgICAgeT0iMjE0LjUwNzIxIj48dHNwYW4KICAgICAgICAgICBzdHlsZT0iZm9udC13ZWlnaHQ6Ym9sZDtmb250LXNpemU6NzkuMTg2OHB4O2ZvbnQtZmFtaWx5OlRhaG9tYTsiCiAgICAgICAgICAgPk9XTjwvdHNwYW4+PHRzcGFuCiAgICAgICAgICAgc3R5bGU9ImZvbnQtc2l6ZTo4LjAzNTEzcHg7Zm9udC1mYW1pbHk6VGFob21hOyIKICAgICAgICAgICA+UEFSVFMgT0Y8L3RzcGFuPjx0c3BhbgogICAgICAgICAgIHN0eWxlPSJmb250LWZhbWlseTpUYWhvbWE7IgogICAgICAgICAgID4KPC90c3Bhbj48L3RzcGFuPjx0c3BhbgogICAgICAgICB4PSIzMzIuNjUzNSIKICAgICAgICAgeT0iMjQ2LjU3Njg3IgogICAgICAgICA+PHRzcGFuCiAgICAgICAgICAgc3R5bGU9ImZvbnQtd2VpZ2h0OmJvbGQ7Zm9udC1zaXplOjM2LjIxNjRweDtmb250LWZhbWlseTpUYWhvbWE7IgogICAgICAgICAgID5FVkVSWVRISU5HPC90c3Bhbj48L3RzcGFuPjwvdGV4dD4KPC9zdmc+Cg==',
        '"}'
      ))))));
  }

  //only owner
 
  function withdraw() public payable onlyOwner {
    
    // This will payout the owner 95% of the contract balance.
    // Do not remove this otherwise you will not be able to withdraw the funds.
    // =============================================================================
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
    // =============================================================================
  }
}