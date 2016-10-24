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

#define SA_Find_Surface_ASL_Under_Position(_object,_positionAGL,_returnSurfaceASL,_canFloat) \
_objectASL = AGLToASL (_object modelToWorldVisual (getCenterOfMass _object)); \
_surfaceIntersectStartASL = [_positionAGL select 0, _positionAGL select 1, (_objectASL select 2) + 1]; \
_surfaceIntersectEndASL = [_positionAGL select 0, _positionAGL select 1, (_objectASL select 2) - 5]; \
_surfaces = lineIntersectsSurfaces [_surfaceIntersectStartASL, _surfaceIntersectEndASL, _object, objNull, true, 5]; \
_returnSurfaceASL = AGLToASL _positionAGL; \
{ \
    scopeName "surfaceLoop"; \
    if( isNull (_x select 2) ) then { \
        _returnSurfaceASL = _x select 0; \
        breakOut "surfaceLoop"; \
    } else { \
        if!((_x select 2) isKindOf "RopeSegment") then { \
            _objectFileName = str (_x select 2); \
            if((_objectFileName find " t_") == -1 && (_objectFileName find " b_") == -1) then { \
                _returnSurfaceASL = _x select 0; \
                breakOut "surfaceLoop"; \
            }; \
        }; \
    }; \
} forEach _surfaces; \
if(_canFloat && (_returnSurfaceASL select 2) < 0) then { \
    _returnSurfaceASL set [2,0]; \
}; \

#define SA_Find_Surface_ASL_Under_Model(_object,_modelOffset,_returnSurfaceASL,_canFloat) \
SA_Find_Surface_ASL_Under_Position(_object, (_object modelToWorldVisual _modelOffset), _returnSurfaceASL,_canFloat);

#define SA_Find_Surface_AGL_Under_Model(_object,_modelOffset,_returnSurfaceAGL,_canFloat) \
SA_Find_Surface_ASL_Under_Model(_object,_modelOffset,_returnSurfaceAGL,_canFloat); \
_returnSurfaceAGL = ASLtoAGL _returnSurfaceAGL;

params ["_vehicle","_vehicleHitchModelPos","_cargo","_cargoHitchModelPos"];

private _maxVehicleSpeed = getNumber (configFile >> "CfgVehicles" >> typeOf _vehicle >> "maxSpeed");
private _cargoCanFloat = if( getNumber (configFile >> "CfgVehicles" >> typeOf _cargo >> "canFloat") == 1 ) then { true } else { false };

private ["_cargoCenterOfMassAGL"];
SA_Find_Surface_AGL_Under_Model(_cargo,getCenterOfMass _cargo,_cargoCenterOfMassAGL,_cargoCanFloat);
private  _cargoModelCenterGroundPosition = _cargo worldToModelVisual _cargoCenterOfMassAGL;
_cargoModelCenterGroundPosition set [0,0];
_cargoModelCenterGroundPosition set [1,0];
_cargoModelCenterGroundPosition set [2, (_cargoModelCenterGroundPosition select 2) - 0.05]; // Adjust height so that it doesn't ride directly on ground

// Calculate cargo model corner points
private _cargoCornerPoints = [_cargo] call AdvLog_fnc_getCornerPoints;
private _corner1 = _cargoCornerPoints select 0;
private _corner2 = _cargoCornerPoints select 1;
private _corner3 = _cargoCornerPoints select 2;
private _corner4 = _cargoCornerPoints select 3;

// Try to set cargo owner if the towing client doesn't own the cargo
if(local _vehicle && !local _cargo) then {
    [_cargo, clientOwner] remoteExec ["AdvLog_fnc_setOwner", 2];
    ///[[_cargo, clientOwner],"SA_Set_Owner"] call SA_RemoteExecServer;
};

_vehicleHitchModelPos set [2,0];
_cargoHitchModelPos set [2,0];

private _lastCargoHitchPosition = _cargo modelToWorld _cargoHitchModelPos;
private _lastCargoVectorDir = vectorDir _cargo;
private _lastMovedCargoPosition = getPos _cargo;

private _cargoHitchPoints = [_cargo] call AdvLog_fnc_getHitchPoints;
private _cargoLength = (_cargoHitchPoints select 0) distance (_cargoHitchPoints select 1);

private _vehicleMass = 1 max (getMass _vehicle);
private _cargoMass = getMass _cargo;
if(_cargoMass == 0) then {
    _cargoMass = _vehicleMass;
};

// Start vehicle speed simulation
[_vehicle] spawn AdvLog_fnc_towingSpeed;

private _doExit = false;
while {!_doExit} do {

    _ropeLength = _vehicle getVariable [QGVAR(towRopeLength), 10];

    private _maxDistanceToCargo = _ropeLength;

    private _vehicleHitchPosition = _vehicle modelToWorld _vehicleHitchModelPos;
    _vehicleHitchPosition set [2,0];
    private _cargoHitchPosition = _lastCargoHitchPosition;
    _cargoHitchPosition set [2,0];

    private _cargoPosition = getPos _cargo;
    private _vehiclePosition = getPos _vehicle;

    if(_vehicleHitchPosition distance _cargoHitchPosition > _maxDistanceToCargo) then {

        // Calculated simulated towing position + direction
        private _newCargoHitchPosition = _vehicleHitchPosition vectorAdd ((_vehicleHitchPosition vectorFromTo _cargoHitchPosition) vectorMultiply _ropeLength);
        private _cargoVector = _lastCargoVectorDir vectorMultiply _cargoLength;
        private _movedCargoVector = _newCargoHitchPosition vectorDiff _lastCargoHitchPosition;
        private _newCargoDir = vectorNormalized (_cargoVector vectorAdd _movedCargoVector);
        //if(_isRearCargoHitch) then {
        //  _newCargoDir = _newCargoDir vectorMultiply -1;
        //};
        _lastCargoVectorDir = _newCargoDir;
        private _newCargoPosition = _newCargoHitchPosition vectorAdd (_newCargoDir vectorMultiply -(vectorMagnitude (_cargoHitchModelPos)));

        SA_Find_Surface_ASL_Under_Position(_cargo,_newCargoPosition,_newCargoPosition,_cargoCanFloat);

        // Calculate surface normal (up) (more realistic than surfaceNormal function)
        private ["_cargoCorner1ASL","_cargoCorner2ASL","_cargoCorner3ASL","_cargoCorner4ASL"];
        SA_Find_Surface_ASL_Under_Model(_cargo,_corner1,_cargoCorner1ASL,_cargoCanFloat);
        SA_Find_Surface_ASL_Under_Model(_cargo,_corner2,_cargoCorner2ASL,_cargoCanFloat);
        SA_Find_Surface_ASL_Under_Model(_cargo,_corner3,_cargoCorner3ASL,_cargoCanFloat);
        SA_Find_Surface_ASL_Under_Model(_cargo,_corner4,_cargoCorner4ASL,_cargoCanFloat);
        private _surfaceNormal1 = (_cargoCorner1ASL vectorFromTo _cargoCorner3ASL) vectorCrossProduct (_cargoCorner1ASL vectorFromTo _cargoCorner2ASL);
        private _surfaceNormal2 = (_cargoCorner4ASL vectorFromTo _cargoCorner2ASL) vectorCrossProduct (_cargoCorner4ASL vectorFromTo _cargoCorner3ASL);
        private _surfaceNormal = _surfaceNormal1 vectorAdd _surfaceNormal2;

        #ifdef DEBUG_MODE_FULL
            if(isNil "sa_tow_debug_arrow_1") then {
                sa_tow_debug_arrow_1 = "Sign_Arrow_F" createVehicleLocal [0,0,0];
                sa_tow_debug_arrow_2 = "Sign_Arrow_F" createVehicleLocal [0,0,0];
                sa_tow_debug_arrow_3 = "Sign_Arrow_F" createVehicleLocal [0,0,0];
                sa_tow_debug_arrow_4 = "Sign_Arrow_F" createVehicleLocal [0,0,0];
            };
            sa_tow_debug_arrow_1 setPosASL _cargoCorner1ASL;
            sa_tow_debug_arrow_1 setVectorUp _surfaceNormal;
            sa_tow_debug_arrow_2 setPosASL _cargoCorner2ASL;
            sa_tow_debug_arrow_2 setVectorUp _surfaceNormal;
            sa_tow_debug_arrow_3 setPosASL _cargoCorner3ASL;
            sa_tow_debug_arrow_3 setVectorUp _surfaceNormal;
            sa_tow_debug_arrow_4 setPosASL _cargoCorner4ASL;
            sa_tow_debug_arrow_4 setVectorUp _surfaceNormal;
        #endif

        // Calculate adjusted surface height based on surface normal (prevents vehicle from clipping into ground)
        private _cargoCenterASL = AGLtoASL (_cargo modelToWorldVisual [0,0,0]);
        _cargoCenterASL set [2,0];
        private _surfaceHeight = ((_cargoCorner1ASL vectorAdd ( _cargoCenterASL vectorMultiply -1)) vectorDotProduct _surfaceNormal1) /  ([0,0,1] vectorDotProduct _surfaceNormal1);
        private _surfaceHeight2 = ((_cargoCorner1ASL vectorAdd ( _cargoCenterASL vectorMultiply -1)) vectorDotProduct _surfaceNormal2) /  ([0,0,1] vectorDotProduct _surfaceNormal2);
        private _maxSurfaceHeight = (_newCargoPosition select 2) max _surfaceHeight max _surfaceHeight2;
        _newCargoPosition set [2, _maxSurfaceHeight ];

        _newCargoPosition = _newCargoPosition vectorAdd ( _cargoModelCenterGroundPosition vectorMultiply -1 );

        _cargo setVectorDir _newCargoDir;
        _cargo setVectorUp _surfaceNormal;
        _cargo setPosWorld _newCargoPosition;

        _lastCargoHitchPosition = _newCargoHitchPosition;
        _maxDistanceToCargo = _vehicleHitchPosition distance _newCargoHitchPosition;
        _lastMovedCargoPosition = _cargoPosition;

        _massAdjustedMaxSpeed = _vehicle getVariable ["SA_Max_Tow_Speed",_maxVehicleSpeed];
        if(speed _vehicle > (_massAdjustedMaxSpeed)+0.1) then {
            _vehicle setVelocity ((vectorNormalized (velocity _vehicle)) vectorMultiply (_massAdjustedMaxSpeed/3.6));
        };

    } else {

        if(_lastMovedCargoPosition distance _cargoPosition > 2) then {
            _lastCargoHitchPosition = _cargo modelToWorld _cargoHitchModelPos;
            _lastCargoVectorDir = vectorDir _cargo;
        };

    };

    // If vehicle isn't local to the client, switch client running towing simulation
    if(!local _vehicle) then {
        _this remoteExec ["AdvLog_fnc_simulateTowing", _vehicle];
        _doExit = true;
    };

    // If the vehicle isn't towing anything, stop the towing simulation
    private ["_currentCargo"];
    if( count (ropeAttachedObjects _vehicle) == 0 ) then {
        _currentCargo = objNull;
    } else {
        _currentCargo = ((ropeAttachedObjects _vehicle) select 0) getVariable ["SA_Cargo",objNull];
    };
    if(isNull _currentCargo) then {
        _doExit = true;
    };

    sleep 0.01;
};
