// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

// Interface para a criação de um token fungivel usando o protocolo ERC20. O Solidity usa o paradigm orientado a contratos. Uma intrface pode ser comparado a uma classe na orientação a objeto.
interface IERC20{

    // O numero maximo de tokens
    function totalSupply() external view returns (uint256);

    // O número de tokens em uma conta
    function balanceOF(address account ) external view returns (uint256);

    //Permite que uma conta gaste o saldo de outra
    function allowance (address owner, address spender) external view returns (uint256);

    //Transfere saldo entre contas
    function transfer (address recipient, uint256 amount ) external returns (bool);

    //Aprova a transferencia
    function approve (address spender,uint256 amount ) external returns (bool);

    // Permite que uma contra faça transferiência em nome de outra conta
    function transferFrom(address spender, address recipient,uint256 amount ) external returns (bool);

    // Quando uma transferência ocorre este aviso é acionado
    event Transfer (address indexed from, address indexed to, uint256 value);

    // Quando uma conta permite que outra gaste em seu nome, esse aviso é acionado
    event Approvel (address indexed owner, address indexed spender, uint256);

}

// Cria o contrato. O Solidity usa o paradigm orientado a contratos. Um contrato pode ser comparado a um objeto na orientação a objeto, que herda caractericas da Interface

contract DIOCoin is IERC20{

    // Características do token
    string public constant name = "DioCoin";
    string public constant symbol= "DIO";
    uint8 public constant decimals = 10;

    // Dados de saldo de cada conta (balances) e os saldos que uma conta pode gastar de outra (allowed)
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    // Número máxiomo de ethers que esse token permite produzir
    uint256 totalSupply_ = 10 ether;

    // O criador do contato possuií todos os tokens
    constructor(){
        balances[msg.sender] = totalSupply_;

    }

    // As funções da interface serão sobrescritas para atender as necessidas do contrato.
    function totalSupply() public override view returns (uint256){
        return totalSupply_;
    }

    function balanceOF( address tokenOwner) public override view returns (uint256){
        return balances[tokenOwner];
    }

    function transfer( address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - numTokens;
        balances[receiver] = balances[receiver] + numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns(bool){
        allowed[msg.sender][delegate] = numTokens;
        emit Approvel(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];

       
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool){

        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner] - numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer] + numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}