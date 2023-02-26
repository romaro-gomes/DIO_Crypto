// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract DigiDIO is ERC721{

    struct Digimon{
        string name;
        uint level;
        string img;
    }

    Digimon[] public digimons;
    address public gameOwner;

    constructor () ERC721 ("DigiDIO", "DWD"){

        gameOwner = msg.sender;

    } 

    modifier onlyOwnerOf(uint _monsterId) {

        require(ownerOf(_monsterId) == msg.sender,"Apenas o tamer pode batalhar com este Digimon");
        _;

    }

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
