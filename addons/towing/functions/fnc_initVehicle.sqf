/*
* Author: DjZonk
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
* Public: No
*/
#include "script_component.hpp"

params [["_vehicle", objNull]];
TRACE_1("params", _vehicle);
private _type = typeof _vehicle;

// do nothing if the class is already initialized
if (_type in GVAR(initializedVehicleClasses_init)) exitWith {};
GVAR(initializedVehicleClasses_init) pushBack _type;

private _config = configFile >> "CfgVehicles" >> _type;

if (getNumber _config >> QGVAR(canTow) == 1 ) then {
    [_vehicle]call FUNC(setCanTow);
};
if (getNumber _config >> QGVAR(canBeTowed) == 1 ) then {
    [_vehicle]call FUNC(setTowable);
};
if ([_vehicle] call AdvLog_fnc_canETow && _vehicle isKindOf "LandVehicle") then {
    [_vehicle] call AdvLog_fnc_towingEmergInit;
};

