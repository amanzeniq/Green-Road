// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CarCarbonEmissionRecord is Ownable {
    struct EmissionRecord {
        string chassisNumber;
        uint256 from;
        uint256 to;
        uint256 engineCapacity; // in cc
        string engineType; // Petrol, Diesel, etc.
        uint256 carbonConsumption; // in grams
        uint256 kilometersDriven;
    }

    mapping(string => EmissionRecord) public emissionsByCarChassisNumber;

    event EmissionRecorded(string indexed chassisNumber);
    event EmissionUpdated(string indexed chassisNumber);

    modifier onlyAdmin() {
        require(msg.sender == owner(), "Only admin can call this function");
        _;
    }

    constructor(address _initialOwner) Ownable(_initialOwner) {}

    function addEmissionRecord(
        string memory _chassisNumber,
        uint256 _from,
        uint256 _to,
        uint256 _engineCapacity,
        string memory _engineType,
        uint256 _carbonConsumption,
        uint256 _kilometersDriven
    ) external onlyAdmin {
        emissionsByCarChassisNumber[_chassisNumber] = EmissionRecord({
            chassisNumber: _chassisNumber,
            from: _from,
            to: _to,
            engineCapacity: _engineCapacity,
            engineType: _engineType,
            carbonConsumption: _carbonConsumption,
            kilometersDriven: _kilometersDriven
        });

        emit EmissionRecorded(_chassisNumber);
    }

    function updateEmissionRecord(
        string memory _chassisNumber,
        uint256 _from,
        uint256 _to,
        uint256 _carbonConsumption,
        uint256 _kilometersDriven
    ) external onlyAdmin {
        require(emissionsByCarChassisNumber[_chassisNumber].carbonConsumption != 0, "Emission record does not exist");

        emissionsByCarChassisNumber[_chassisNumber].from = _from;
        emissionsByCarChassisNumber[_chassisNumber].to = _to;
        emissionsByCarChassisNumber[_chassisNumber].carbonConsumption = _carbonConsumption;
        emissionsByCarChassisNumber[_chassisNumber].kilometersDriven = _kilometersDriven;

        emit EmissionUpdated(_chassisNumber);
    }

    function calculateCarbonSavings(string memory _chassisNumber) public view returns (bool isCarbonSaved, uint256 savedAmount) {
    EmissionRecord memory emission = emissionsByCarChassisNumber[_chassisNumber];

    uint256 requiredCarbon = 0;

    if (keccak256(abi.encodePacked((emission.engineType))) == keccak256(abi.encodePacked(("diesel")))) {
        if (emission.engineCapacity <= 1500) {
            requiredCarbon = 2000;
        } else if (emission.engineCapacity <= 2000) {
            requiredCarbon = 2500;
        } else {
            requiredCarbon = 3000;
        }
    } else if (keccak256(abi.encodePacked((emission.engineType))) == keccak256(abi.encodePacked(("E-plus")))) {
        requiredCarbon = emission.engineCapacity * 1;
    } else if (keccak256(abi.encodePacked((emission.engineType))) == keccak256(abi.encodePacked(("special")))) {
        requiredCarbon = emission.engineCapacity * 2;
    } else if (keccak256(abi.encodePacked((emission.engineType))) == keccak256(abi.encodePacked(("super")))) {
        requiredCarbon = emission.engineCapacity * 3;
    } else {
        // Default to diesel if engine type is not recognized
        if (emission.engineCapacity <= 1500) {
            requiredCarbon = 2000;
        } else if (emission.engineCapacity <= 2000) {
            requiredCarbon = 2500;
        } else {
            requiredCarbon = 3000;
        }
    }

    if (emission.carbonConsumption <= requiredCarbon) {
        return (true, requiredCarbon - emission.carbonConsumption);
    } else {
        return (false, emission.carbonConsumption - requiredCarbon);
    }
}
}
