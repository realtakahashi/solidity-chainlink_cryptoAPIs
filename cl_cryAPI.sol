pragma solidity ^0.6.0;

//import "https://github.com/smartcontractkit/chainlink/evm/contracts/ChainlinkClient.sol";
import "https://github.com/smartcontractkit/chainlink/evm-contracts/src/v0.6/ChainlinkClient.sol";

contract CryptoAPIsChainlink is ChainlinkClient {
  
  uint256 oraclePayment;

//   constructor(uint256 _oraclePayment) public  {
//     setPublicChainlinkToken();
//     oraclePayment = _oraclePayment;
//     owneraddress = msg.sender;
//   }
  constructor(uint256 _oraclePayment) public  {
    setPublicChainlinkToken();
    oraclePayment = _oraclePayment;
    owneraddress = msg.sender;
  }

  // Additional functions here:
  
  function requestPrice
  (
    address _oracle,
    bytes32 _jobId,
    string memory _coin,
    string memory _market
  )
    public
    //onlyOwner
  {
    Chainlink.Request memory req = buildChainlinkRequest(_jobId, address(this), this.fulfill.selector);
    req.add("coin", _coin);
    req.add("market", _market);
    req.addInt("times", 100);
    sendChainlinkRequestTo(_oracle, req, oraclePayment);
  }
  
  uint256 public currentPrice;

  function fulfill(bytes32 _requestId, uint256 _price)
    public
    recordChainlinkFulfillment(_requestId)
  {
    currentPrice = _price;
  }
  
  address owneraddress;
  modifier onlyOwner {
    require(owneraddress == msg.sender);
    _;
  }
}
