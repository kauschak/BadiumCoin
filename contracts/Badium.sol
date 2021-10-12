pragma solidity >=0.5.0 <0.6.0;

import "./Ownable.sol";
import "./IEIP20.sol";

contract Badium is IEIP20, Ownable {
 
    uint256 constant MAX = ~uint256(0);
    string constant COIN_NAME = "Badium";
    string constant COIN_SYMBOL = "BAD";
    uint256 constant INITIAL_TOTAL_SUPPLY = 10000000;
    uint256 constant EXCHANGE_RATE = 0.01 ether;
  
    uint256 private currentCirculatorySystem;
    uint256 private latestCirculatorySystem;
    
    //Represents holder addresses => cirulatorySystem => balance amounts
    mapping(address => mapping(uint256 => uint256)) private balances;
    //Represents current Circulatory System => total token
    mapping(uint256 => uint256) private totalTokenSupply;
    //Represent reciever address => active or inactive flag
    mapping(address => bool) private allowedReceivers;
    //Represents Sender address => Spender address => Max approved amount.
    mapping(address => mapping(address => uint256)) private allowances;
    
  
    constructor() public {
        currentCirculatorySystem = 0;
        latestCirculatorySystem = 0;
        totalTokenSupply[currentCirculatorySystem] = INITIAL_TOTAL_SUPPLY;
        balances[owner()][currentCirculatorySystem] = totalTokenSupply[currentCirculatorySystem];
    }
  
    /**
     * Returns the name of the token
     */
    function name() external view returns (string memory) {
        return COIN_NAME;
    }
    /**
     * Returns the symbol of the token. 
     */
    function symbol() external view returns (string memory) {
        return COIN_SYMBOL;
    }
    /** 
     * Returns the number of decimals the token uses - e.g. 8, means to divide the token amount by 100000000 to get its user representation.
     * As per Ether & Wei relationship usually token are of value 18.
     */
    function decimals() external view returns (uint8) {
        return 0;
    }
    /**
     * Returns the total token supply.
     */
    function totalSupply() external view returns (uint256) {
        return totalTokenSupply[currentCirculatorySystem];
    }
    /**
     * Returns the account balance of holder account with address.
     */
    function balanceOf(address _holder) external view returns (uint256 balance) {
        return balances[_holder][currentCirculatorySystem];
    }
     /**
      * Transfers _value amount of tokens to address _to, and MUST fire the Transfer event.
      * The function SHOULD throw if the message caller’s account balance does not have enough tokens to spend.
      * Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
      */
    function transfer(address _to, uint256 _value) external returns (bool success) {
        _transfer(_msgSender(), _to, _value);
        return true;
    }
    /**
     * The transferFrom method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf. 
     * This can be used for example to allow a contract to transfer tokens on your behalf and/or to charge fees in sub-currencies. 
     * The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism.
     * Emits an Approval event indicating the updated allowance.
     */
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
        _transfer(_from, _to, _value);
        uint256 currentAllowance = allowances[_from][_msgSender()];
        require(currentAllowance >= _value, "Badium Token: transfer amount exceeds allowance");
        allowances[_from][_msgSender()] = currentAllowance - _value;
        emit Approval(_from, _msgSender(), _value);
        return true;
    }
    /**
     * Allows _spender to withdraw from holder account multiple times, up to the _value amount. 
     * If this function is called again it overwrites the current allowance with _value
     */
    function approve(address _spender, uint256 _value) external returns (bool success) {
        require(_spender != address(0), "Badium Token: approve to the invalid or zero address");
        allowances[_msgSender()][_spender] = _value;
        emit Approval(_msgSender(), _spender, _value);
        return true;
    }
    /**
     * Returns the amount which _spender is still allowed to withdraw from _owner or holder.
     * The maximum amount that the spender is approved to transfer from the holder's tokens.
     */
    function allowance(address _holder, address _spender) external view returns (uint256 remaining) {
        return allowances[_holder][_spender];
    }
    /**
     * Adds the address to the list of allowed receivers.
     */
    function addReceiver(address receiver) external onlyOwner returns (bool) {
        allowedReceivers[receiver] = true;
        return true;
    }
    /**
     * Removes or deactivate the given address from the list of approved receivers.
     */
    function removeReceiver(address receiver) external onlyOwner returns (bool) {
        allowedReceivers[receiver] = false;
        return true;
    }
    /**
     * Increase total supply of Badium token.
     * Specified amount is added to Owner's account
     * Emits a Transfer event with 'from' set to the zero address.
     */
    function mint(uint256 _amount) external onlyOwner returns (bool) {
        require(_amount <= MAX - totalTokenSupply[currentCirculatorySystem], "Badium Token: Total supply exceeded max limit.");
        totalTokenSupply[currentCirculatorySystem] += _amount;
        require(_amount <= MAX - balances[owner()][currentCirculatorySystem], "Badium Token: Balance of owner exceeded max limit.");
        balances[owner()][currentCirculatorySystem] += _amount;
        emit Transfer(address(0), owner(), _amount);
        return true;
    }
    /**
     * Burns specified amount of token from given holder's account
     * Emits a Transfer event with 'to' set to the zero address.
     */
    function burn(address _holder, uint256 _amount) external onlyOwner returns (bool) {
        require(_holder != address(0), "Badium Token: burn from the zero address");
        uint256 accountBalance = balances[_holder][currentCirculatorySystem];
        require(accountBalance >= _amount, "Badium Token: burn amount exceeds balance of the holder");
        balances[_holder][currentCirculatorySystem] = accountBalance - _amount;
        require(_amount <= totalTokenSupply[currentCirculatorySystem], "Badium Token: Insufficient total supply.");
        totalTokenSupply[currentCirculatorySystem] -= _amount;
        emit Transfer(_holder, address(0), _amount);
        return true;
    }
    /**
     * Burn all tokens in current circulatory system index
     */
    function burnAll() external onlyOwner returns (bool) {
        require(1 <= MAX - latestCirculatorySystem, "Badium Token: Circulatory System count limit exceeded.");
        latestCirculatorySystem ++;
        currentCirculatorySystem = latestCirculatorySystem;
        return true;
    }
    /**
     * Returns current Badium Token circulatory system index
     */
    function getCurrentCirculatorySystem() external view returns (uint256) {
        return currentCirculatorySystem;
    }
    /**
     * Select any existing Badium Token circulatory system to switch between different circulatory systems
     */
    function selectCirculatorySystem(uint256 _index) external onlyOwner returns (bool) {
        require(_index <= latestCirculatorySystem, "Badium Token: Invalid circulatory system index");
        currentCirculatorySystem = _index;
        return true;
    }
    /**
     * Buy given amount of Badium token from Owner with given exchange rate of 0.01 ether.
     * Bought tokens are credited to the message sender.
     * Owner recieves the transferred ether balance from contract.
     * Emits a Transfer event with Owner as sender & transaction initiator as receiver.
     */
    function buy(uint256 _amount) external payable returns (bool) {
        require(_msgValue() > 0, "Badium Token: Invalid Transaction");
        require(_msgValue() % EXCHANGE_RATE == 0 && _msgValue() / EXCHANGE_RATE == _amount, "Badium Token: Invalid Transaction Value");
        
        _transfer(owner(), _msgSender(), _amount);
        uint256 balanceAmt = address(this).balance;
        receiveFundToOwner(balanceAmt);
        return true;
    }
    /**
     * Internal method that returns msg.sender
     */
    function _msgSender() internal view returns (address) {
        return msg.sender;
    }
    /**
     * Internal method that returns msg.value
     */
    function _msgValue() internal view returns (uint256) {
        return msg.value;
    }
    /**
     * Internal method that does transfer Badium token from one account to another
     */
    function _transfer(address _sender, address _recipient, uint256 _amount) internal {
        require(_sender != address(0), "Badium Token: Invalid Sender Address");
        require(_recipient != address(0), "Badium Token: Invalid Recipient Address");
        require(allowedReceivers[_recipient], "Badium Token: Invalid receiver.");
        
        uint256 balanceAmt = balances[_sender][currentCirculatorySystem];
        require(balanceAmt >= _amount, "Badium Token: Transfer amount exceeds balance of sender");
        require(_amount <= MAX - balances[_recipient][currentCirculatorySystem], "Badium Token: Balance limit exceeded for Recipient.");
        
        balances[_sender][currentCirculatorySystem] = balanceAmt - _amount;
        balances[_recipient][currentCirculatorySystem] += _amount;
        
        emit Transfer(_sender, _recipient, _amount);
    }
  
}
