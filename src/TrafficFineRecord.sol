// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract TrafficFineRecord is Ownable {
    struct Fine {
        uint256 time;
        uint256 fineAmount;
        string fineType;
        string location;
        string vehicleNumberPlate;
        string vehicleChassisNumber;
    }

    mapping(string => Fine[]) private finesByLicenseNumber;

    event FineRecorded(string indexed licenseNumber, uint256 fineIndex);
    event FineModified(string indexed licenseNumber, uint256 fineIndex, uint256 newFineAmount);
    event FineDeleted(string indexed licenseNumber, uint256 fineIndex);
    event AllFinesDeleted(string indexed licenseNumber);

    constructor(address _initialOwner) Ownable(_initialOwner) {}

    function recordFine(
        string memory _licenseNumber,
        uint256 _time,
        uint256 _fineAmount,
        string memory _fineType,
        string memory _location,
        string memory _vehicleNumberPlate,
        string memory _vehicleChassisNumber
    ) external onlyOwner {
        finesByLicenseNumber[_licenseNumber].push(Fine({
            time: _time,
            fineAmount: _fineAmount,
            fineType: _fineType,
            location: _location,
            vehicleNumberPlate: _vehicleNumberPlate,
            vehicleChassisNumber: _vehicleChassisNumber
        }));

        emit FineRecorded(_licenseNumber, finesByLicenseNumber[_licenseNumber].length - 1);
    }

    function modifyFine(string memory _licenseNumber, uint256 _fineIndex, uint256 _newFineAmount) external onlyOwner {
        require(finesByLicenseNumber[_licenseNumber].length > 0, "License number does not exist");
        require(_fineIndex < finesByLicenseNumber[_licenseNumber].length, "Fine index out of range");

        finesByLicenseNumber[_licenseNumber][_fineIndex].fineAmount = _newFineAmount;

        emit FineModified(_licenseNumber, _fineIndex, _newFineAmount);
    }

    function deleteFine(string memory _licenseNumber, uint256 _fineIndex) external onlyOwner {
        require(finesByLicenseNumber[_licenseNumber].length > 0, "License number does not exist");
        require(_fineIndex < finesByLicenseNumber[_licenseNumber].length, "Fine index out of range");

        // Move the last element to the deleted position and decrease array length
        uint256 lastIndex = finesByLicenseNumber[_licenseNumber].length - 1;
        finesByLicenseNumber[_licenseNumber][_fineIndex] = finesByLicenseNumber[_licenseNumber][lastIndex];
        finesByLicenseNumber[_licenseNumber].pop();

        emit FineDeleted(_licenseNumber, _fineIndex);
    }

    function getFineCount(string memory _licenseNumber) external view returns (uint256) {
        return finesByLicenseNumber[_licenseNumber].length;
    }

    function getFineByLicenseNumber(string memory _licenseNumber, uint256 _index) external view returns (
        uint256 time,
        uint256 fineAmount,
        string memory fineType,
        string memory location,
        string memory vehicleNumberPlate,
        string memory vehicleChassisNumber
    ) {
        Fine memory fine = finesByLicenseNumber[_licenseNumber][_index];
        return (fine.time, fine.fineAmount, fine.fineType, fine.location, fine.vehicleNumberPlate, fine.vehicleChassisNumber);
    }

    function getAllFinesByLicenseNumber(string memory _licenseNumber) external view returns (Fine[] memory) {
        return finesByLicenseNumber[_licenseNumber];
    }

    function getAllFineIndicesByLicenseNumber(string memory _licenseNumber) external view returns (uint256[] memory) {
        Fine[] storage fines = finesByLicenseNumber[_licenseNumber];
        uint256[] memory indices = new uint256[](fines.length);
        for (uint256 i = 0; i < fines.length; i++) {
            indices[i] = i;
        }
        return indices;
    }

    function deleteAllFinesByLicenseNumber(string memory _licenseNumber) external onlyOwner {
        require(finesByLicenseNumber[_licenseNumber].length > 0, "License number does not exist");

        delete finesByLicenseNumber[_licenseNumber];

        emit AllFinesDeleted(_licenseNumber);
    }
}
