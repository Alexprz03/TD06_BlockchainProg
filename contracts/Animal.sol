pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
import "./Context.sol";
import "./IERC721.sol";
import "./IERC721Receiver.sol";
import "./SafeMath.sol";
import "./Address.sol";
import "./Counters.sol";
import "./ERC165.sol";
import "./ERC721.sol";
import "./Ownable.sol";


contract Animal is ERC721, Ownable{
    using SafeMath for uint256;
	uint index = 0;
	uint public index_market = 0;
	
	animal[] public animals;
    address[] public Owners;
    auction[] public auctions;
	

    struct animal{
		string specie;
		string name;
		uint age;
		uint256 iDparent1;
		uint256 iDparent2;
		string color;
        bool fight;
        uint256 fightPrice;
	}
	
	struct auction{
        uint256 Idmarketplace;
        uint time_start;
        uint256 IDanimal;
        uint256 price;
        string state;
    }

	event NewAnimal(uint Id, string _specie, string _name, uint _age, uint256 _iDparent1, uint256 _iDparent2, string _color, bool _fight, uint256 _fightPrice);
	event DeadAnimal(uint Id, string _specie, string _name, uint _age, uint256 _iDparent1, uint256 _iDparent2, string _color, bool _fight, uint256 _fightPrice);
	event BreedAnimal(uint Id1, uint Id2);
    event addAuction(uint256 IdAuction);
	event AddedToWhitelist(address indexed account);
    event RemovedFromWhitelist(address indexed account);
	
    mapping(address => bool) whitelist;
    mapping (address => uint) ownerAnimalCount;
    mapping (uint => address) animalToOwner;
    mapping (string => uint) nameToId;
	
	
	modifier onlyWhitelisted() {
        require(isWhitelisted(msg.sender),"Verify if it's in the whitelist");
        _;
    }
	
    function registerBreeder(address _address) public onlyOwner{
        whitelist[_address] = true;
        emit AddedToWhitelist(_address);
    }
	
    function removeBreeder(address _address) public  onlyOwner{
        whitelist[_address] = false;
        emit RemovedFromWhitelist(_address);
    }
	
    function isWhitelisted(address _address) public view returns(bool) {
        return whitelist[_address];
    }
	
	function declareAnimal(address _owner, string memory _specie, uint _age, uint256 _iDparent1, uint256 _iDparent2, string memory _name, string memory _color) public {
        require(msg.sender == _owner, "You are not declaring your animal");
		animal memory new_a = animal(_specie, _name, _age, 0, 0, _color, false, 0);
		animals.push(new_a);
		
        ownerAnimalCount[msg.sender]++;
		animals.push(new_a);
        animalToOwner[index] = msg.sender;
        nameToId[_name] = index;
        
		emit NewAnimal(index, _specie, _name, _age, _iDparent1, _iDparent2, _color, false, 0);
		
		index++;
    }
	
    function deadAnimal(uint256 Id_animal) public{
		address owner = animalToOwner[Id_animal];
        ownerAnimalCount[owner]--;
		delete(animals[Id_animal]);

        animalToOwner[Id_animal] = address(0);

        emit DeadAnimal(Id_animal, animals[Id_animal].specie, animals[Id_animal].name, animals[Id_animal].age, animals[Id_animal].iDparent1, animals[Id_animal].iDparent2, animals[Id_animal].color, animals[Id_animal].fight, animals[Id_animal].fightPrice);
    }

	
	function breedAnimal(address owner1, address owner2, uint256 Id_animal1, uint256 Id_animal2, string memory _name) public onlyWhitelisted{
        require(animalToOwner[Id_animal1] == owner1, "Verify if Owner 1 has Animal 1");
        require(animalToOwner[Id_animal2] == owner2, "Verify if Owner 2 has Animal 2");

		emit BreedAnimal(Id_animal1, Id_animal2);
		declareAnimal(owner1, animals[Id_animal1].specie, 0, Id_animal1, Id_animal2, _name,  animals[Id_animal1].color);
    }

	function proposeToFight(address owner, uint256 Id_animal, uint price) public onlyWhitelisted{
        require(animalToOwner[Id_animal] == owner, "Verify if Owner 1 has Animal 1");
		
        animals[Id_animal].fight = true;
        animals[Id_animal].fightPrice = price;
    }
	
	function agreeToFight(uint256 Id_animal, uint256 Id_animal2) public onlyWhitelisted{
		require(animals[Id_animal].fight == true, "Verify that first animal can fight");
        require(animals[Id_animal2].fight == true,"Need to be able to fight");
        require(animals[Id_animal2].fightPrice == animals[Id_animal].fightPrice,"Need to bet the same amount");
		
        animals[Id_animal].fight = false;
		animals[Id_animal].fightPrice = 0;
        animals[Id_animal2].fight = false;
        animals[Id_animal2].fightPrice = 0;
    }
	
	
	function createAuction(address owner, uint256 Id_animal, uint price) public{
        require(animalToOwner[Id_animal] == owner, "Verify if Owner 1 has Animal 1");
		
		auction memory new_auct = auction(index_market, (block.timestamp), Id_animal, price, "In progress");
        auctions.push(new_auct);
        emit addAuction(index_market);
		index_market++;
    }
	
	//function BidOnAuction(uint public index_market){
	//}
	
	//function ClaimAuction(uint public index_market){
	//}
	
}