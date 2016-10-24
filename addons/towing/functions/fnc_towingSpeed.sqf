/*
Modified by Sean Crowe
please see orginal work @ forums.bistudio.com/topic/188980-advanced-towing

To get a full list of changes please contant me on the biforums under the username S.Crowe

The MIT License (MIT)

Copyright (c) 2016 Seth Duda

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
/*
* Author: [Name of Author(s)]
* [Description]
*
* Arguments:
* 0: Argument Name <TYPE>
*
* Return Value:
* Return Name <TYPE>
*
* Example:
* ["example"] call r3fadvlog_[module]_fnc_[functionName]
*
* Public: [Yes/No]
*/
#include "script_component.hpp"

params ["_vehicle"];

private ["_currentCargo"];

private _maxVehicleSpeed = getNumber (configFile >> "CfgVehicles" >> typeOf _vehicle >> "maxSpeed");
private _vehicleMass = 1000 max (getMass _vehicle);
private _maxTowedCargo = QGVAR(maxTrainLength);
private _runSimulation = true;

while {_runSimulation} do {

    // Calculate total mass and count of cargo being towed (only takes into account
    // cargo that's actively being towed (e.g. there's no slack in the rope)

    private _currentVehicle = _vehicle;
    private _totalCargoMass = 0;
    private _totalCargoCount = 0;
    private _findNextCargo = true;
    while {_findNextCargo} do {
        _findNextCargo = false;
        if(count (ropeAttachedObjects _currentVehicle) == 0 ) then {
            _currentCargo = objNull;
        } else {
            _currentCargo = ((ropeAttachedObjects _currentVehicle) select 0) getVariable ["SA_Cargo",objNull];
        };
        if(!isNull _currentCargo) then {
            private _towRopes = _currentVehicle getVariable [QGVAR(towRope),[]];
            if(count _towRopes > 0) then {
                private _ropeLength = ropeLength (_towRopes select 0);
                private _ends = ropeEndPosition (_towRopes select 0);
                private _endsDistance = (_ends select 0) distance (_ends select 1);
                if( _endsDistance >= _ropeLength - 2 ) then {
                    _totalCargoMass = _totalCargoMass + (1000 max (getMass _currentCargo));
                    _totalCargoCount = _totalCargoCount + 1;
                    _currentVehicle = _currentCargo;
                    _findNextCargo = true;
                };
            };
        };
    };

    private _newMaxSpeed = _maxVehicleSpeed / (1 max ((_totalCargoMass /  _vehicleMass) * 2));
    _newMaxSpeed = (_maxVehicleSpeed * 0.75) min _newMaxSpeed;

    // Prevent vehicle from moving if trying to move more cargo than pre-defined max
    if(_totalCargoCount > _maxTowedCargo) then {
        _newMaxSpeed = 0;
    };

    private _currentMaxSpeed = _vehicle getVariable ["SA_Max_Tow_Speed",_maxVehicleSpeed];

    if(_currentMaxSpeed != _newMaxSpeed) then {
        _vehicle setVariable ["SA_Max_Tow_Speed",_newMaxSpeed];
    };

    sleep 0.1;

};
