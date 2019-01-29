pragma solidity ^0.4.23;
//Importing openzeppelin-solidity ERC-721 implemented Standard
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721.sol';
// StarNotary Contract declaration inheritance the ERC721 openzeppelin implementatio
contract StarNotary is ERC721 {
    struct Star {
        string name;
    }

  // Implement Task 1 Add a name and symbol properties
 // name: Is a short name to your token
 // symbol: Is a short string like 'USD' -> 'American Dollar'

// ----- ERC-721 Token Name: and Symbol---------------
    string public  name = "HMM StarNotary";
    string public  symbol ="HMM";
    //uint8 public decimal = 18;
//----------------------------------------------------
    // uint256 public totalSupply = 1000000;
    //uint _totalSupply ;

    // Balances for each account stored using a mapping
  //  mapping(address => uint256) balances;

  //  constructor() public {
  //      uint amount =1000000;
    //    _totalSupply = amount;
    //    balances[msg.sender] = amount;
  //  }

    /* Returns the total supply of tokens
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }
*/
    function setName(string _name) public{
        name = _name;
    }

    function setSymbol(string _symbol) public{
        symbol = _symbol;
    }
//
    // mapping the Star with the Owner Address
    mapping(uint256 => Star) public tokenIdToStarInfo;
      // mapping the TokenId and price
    mapping(uint256 => uint256) public starsForSale;


  // -------------- Create Star-------------------------
    function createStar(string _name, uint256 _tokenId) public {
        Star memory newStar = Star(_name);
        tokenIdToStarInfo[_tokenId] = newStar;
        _mint(msg.sender, _tokenId);
    }

  // -------------- lookUptokenIdToStarInfo task 1-------------------------
    function lookUptokenIdToStarInfo(uint256 _tokenId) public view returns (string ) {
        Star memory s = tokenIdToStarInfo[_tokenId];
        return s.name;
    }
  //-------------------------------------------------------
  ///////////////////////////////////////////////////////////////////////////
  // Putting an Star for sale -----------------------------------------------
    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender);

        starsForSale[_tokenId] = _price;
    }
//--------------------------------------------------------------------------
    function buyStar(uint256 _tokenId) public payable {
        require(starsForSale[_tokenId] > 0);
        uint256 starCost = starsForSale[_tokenId];
        address starOwner = ownerOf(_tokenId);
        require(msg.value >= starCost);
        _removeTokenFrom(starOwner, _tokenId);
        _addTokenTo(msg.sender, _tokenId);
        starOwner.transfer(starCost);
        if(msg.value > starCost) {
            msg.sender.transfer(msg.value - starCost);
        }
        starsForSale[_tokenId] = 0;
    }

//--------------Exchange Stars function------------------------------
    function exchangeStars(uint256 _tokenId1, uint256 _tokenId2) public{

      //1. Passing to star tokenId you will need to check if the owner of _tokenId1 or _tokenId2 is the sender
      //2. You don't have to check for the price of the token (star)
      //3. Get the owner of the two tokens (ownerOf(_tokenId1), ownerOf(_tokenId1)
      //4. Use _transferFrom function to exchange the tokens.
        address user1 = ownerOf(_tokenId1);
        address user2 = ownerOf(_tokenId2);
        _removeTokenFrom(user1, _tokenId1);
        _addTokenTo( user2, _tokenId1);
        _removeTokenFrom(user2, _tokenId2);
        _addTokenTo( user1, _tokenId2);
        require(_checkOnERC721Received(user1, user2, _tokenId1, ""));
        require(_checkOnERC721Received(user2, user1, _tokenId1, ""));
    }

//------------------------Transfer Stars--------------------------------
    function transferStar(address _to, uint256 _tokenId) public{
      //1. Check if the sender is the ownerOf(_tokenId)
      //2. Use the transferFrom(from, to, tokenId); function to transfer the Star
        _removeTokenFrom(msg.sender, _tokenId);
        _addTokenTo(_to, _tokenId);
        emit Transfer(msg.sender, _to, _tokenId);
    }
}
