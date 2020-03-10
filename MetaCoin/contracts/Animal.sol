pragma solidity ^0.6.1;

import "./ownable.sol";
import  "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721Burnable.sol";

contract Animal is Ownable, ERC721 {

    event NewAnimal(uint animalId, string name );

    struct Animal{       
        string ttype;
        string name;
        string sexe;
        string couleur;
        uint age;
        uint poids;


    }


    Animal[] public animaux;


    function declareAnimal(string _type, string _name, string _sexe, string  _couleur,uint _age, uint _poids) public {

       uint id = animaux.push(declareAnimal(_type,_name,_sexe,_couleur,_age,_poids)) - 1;
       emit NewAnimal(id, _name);

    }

    function deadAnimal(uint _id) public {
        burn(id);
    }

    

   

}
