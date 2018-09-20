pragma solidity ^0.4.23;

contract MultiStorage{
    mapping (address => bool ) private _initedSymbol;
    mapping (address => string) private _symbol;
    mapping (address => bool) private _initedName;
    mapping (address => string) private _name;
    mapping (address => bool) private _initedDecimals ;
    mapping (address => uint8) private _decimals;
    mapping (address => bool) private _initedTotalSupply;
    mapping (address => uint256) private _totalSupply;
    mapping (address => mapping (address => uint256)) private _balanceOf;
    mapping (address => mapping (address => mapping (address => uint256))) private _allowances;
    // allownce access
    mapping(address => bool) private accessAllowed;
    
    struct AddrValueMap {
        address balanceAddr;
        uint256 balanceValue;
    }
    struct Allowance {
        address allownceAddr;
        AddrValueMap allownceValue;
    }

    constructor()public{
        accessAllowed[msg.sender] = true;
    }

    modifier isPlatform() {
        require(accessAllowed[msg.sender] == true,"the address not allowed the storage!");
        _;
    }
    // 
    function allowAccess(address _address)   public isPlatform {
        accessAllowed[_address] = true;
    }
    // 
    function denyAccess(address _address)  public isPlatform {
        accessAllowed[_address] = false;
    }

    // get name 
    function getName(address _contractAddr) public view returns(string){
        return _name[_contractAddr];
    }
    // set name 
    // 
    function setName(address _contractAddr,string name) public isPlatform returns(bool){
        if (!_initedName[_contractAddr]) {
            _name[_contractAddr] = name;
            _initedName[_contractAddr] = true;
            return true;
        } else {
            return false;
        }
       
    }
    // get symbol
    function getSymbol(address _contractAddr) public view returns(string){
        return _symbol[_contractAddr];
    }
    // set symbol
    // 
    function setSymbol(address _contractAddr,string symbol) public  isPlatform returns(bool){
        if (!_initedSymbol[_contractAddr]) {
            _symbol[_contractAddr] = symbol;
            _initedSymbol[_contractAddr] = true;
            return true;
        } else {
            return false;
        }
    }
    // get decimals
    function getDecimals(address _contractAddr) public view returns(uint8){
        return _decimals[_contractAddr];
    }
    // set _decimals
    function setDecimals(address _contractAddr,uint8 decimals) public isPlatform returns(bool){
        if (!_initedDecimals[_contractAddr]) {
            _decimals[_contractAddr] = decimals;
            _initedDecimals[_contractAddr] = true;
            return true;
        } else {
            return false;
        }
    }
    // set total supply
    // isPlatform
    function setTotalSupply(address _contractAddr, uint256 total) public  returns (bool) {
        if (!_initedTotalSupply[_contractAddr]) {
            _totalSupply[_contractAddr] = total;
            _initedTotalSupply[_contractAddr] = true;
            _balanceOf[_contractAddr][_contractAddr] = _totalSupply[_contractAddr];
            return true;
        } else {
            return false;
        }
    }
    // get total supply
    function getTotalSupply(address _contractAddr) public view returns (uint256) {
        return _totalSupply[_contractAddr];
    }
    // get balance of address
    function getBalanceOf(address _contractAddr,address _addr) public view returns (uint256){
        return _balanceOf[_contractAddr][_addr];
    }
    // set Transfer value
    // 
    function setBalanceOf(address _contractAddr,address _addr, uint256 _value) public isPlatform  returns(bool) {
        _balanceOf[_contractAddr][_addr] =  _value;
        return true;
    }
    // set _allowances
    function setAllowances(address _contractAddr,address _sender,address _spender, uint256 _value) public isPlatform returns(bool){
        _allowances[_contractAddr][_sender][_spender] = _value;
        return true;
    }
    //  get allowance
    function getAllowances(address _contractAddr,address _owner, address _spender) public view returns (uint256){
        return _allowances[_contractAddr][_owner][_spender];
    }

    function kill(address _contractAddr) public isPlatform {
        delete _initedSymbol[_contractAddr];
        delete _symbol[_contractAddr];
        delete _initedName[_contractAddr];
        delete _name[_contractAddr];
        delete _initedDecimals[_contractAddr];
        delete _decimals[_contractAddr];
        delete _initedTotalSupply[_contractAddr];
        delete _totalSupply[_contractAddr];
        
        delete _balanceOf[_contractAddr];
        delete _allowances[_contractAddr];
    }
}