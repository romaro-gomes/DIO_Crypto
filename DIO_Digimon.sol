// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

// Importa  a interface do contrato
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

//Cria o contrato
contract DigiDIO is ERC721{

// Cria as caracteriticas do contrato
    struct Digimon{
        string name;
        uint level;
        string img;
    }

// Cria uma lista de digimons
    Digimon[] public digimons;
    address public gameOwner;

// Inicia o contrato
    constructor () ERC721 ("DigiDIO", "DWD"){

        gameOwner = msg.sender;

    } 

// O moificador cria um critério para a utilização desse contrato
    modifier onlyOwnerOf(uint _monsterId) {

        require(ownerOf(_monsterId) == msg.sender,"Apenas o tamer pode batalhar com este Digimon");
        _;

    }

// Cria funções específicas para este contrato
    function battle(uint _attackingDigimon, uint _defendingDigimon) public onlyOwnerOf(_attackingDigimon){
        Digimon storage attacker = digimons[_attackingDigimon];
        Digimon storage defender = digimons[_defendingDigimon];

         if (attacker.level >= defender.level) {
            attacker.level += 2;
            defender.level += 1;
        }else{
            attacker.level += 1;
            defender.level += 2;
        }
    }

    function createNewDigimon(string memory _name, address _to, string memory _img) public {
        require(msg.sender == gameOwner, "Apenas o dono do jogo pode criar novos Digimons");
        uint id = Digimons.length;
        Digimons.push(Digimon(_name, 1,_img));
        _safeMint(_to, id);
    }


}
