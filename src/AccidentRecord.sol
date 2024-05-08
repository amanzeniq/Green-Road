// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CarAccidentRecord is Ownable {
    struct Accident {
        string chassisNumber;
        bool isLiable;
        uint256 fine;
        uint256 date;
        string affectedParts;
        string location;
        string[] photoURLs;
        string details;
    }

    mapping(uint256 => Accident) public accidents;
    mapping(string => uint256[]) public accidentsByCarChassisNumber;
    uint256 public totalAccidents;

    event AccidentRecorded(uint256 indexed accidentId);

    mapping(address => bool) public police;

    modifier onlyPolice() {
        require(msg.sender == owner(), "Only owner (police) can call this function");
        _;
    }

     constructor() Ownable() {
        police[msg.sender] = true;
    }

    function addCarAccidentRecord(
        string memory _chassisNumber,
        bool _isLiable,
        uint256 _fine,
        uint256 _date,
        string memory _affectedParts,
        string memory _location,
        string[] memory _photoURLs,
        string memory _details
    ) external onlyPolice {
        accidents[totalAccidents] = Accident({
            chassisNumber: _chassisNumber,
            isLiable: _isLiable,
            fine: _fine,
            date: _date,
            affectedParts: _affectedParts,
            location: _location,
            photoURLs: _photoURLs,
            details: _details
        });

        accidentsByCarChassisNumber[_chassisNumber].push(totalAccidents);

        totalAccidents++;
        emit AccidentRecorded(totalAccidents - 1);
    }

    function getCarAccidentHistory(string memory _chassisNumber) external view returns (Accident[] memory) {
        uint256[] memory accidentIds = accidentsByCarChassisNumber[_chassisNumber];
        Accident[] memory history = new Accident[](accidentIds.length);

        for (uint256 i = 0; i < accidentIds.length; i++) {
            history[i] = accidents[accidentIds[i]];
        }

        return history;
    }

    function getAccidentIdsByCarChassisNumber(string memory _chassisNumber) external view returns (uint256[] memory) {
        return accidentsByCarChassisNumber[_chassisNumber];
    }
}
