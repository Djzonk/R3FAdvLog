/*
* Author: DjZonk
* adds cargo actions to vehicles
*
* Arguments:
* 0: Vehicle <OBJECT>
*
* Return Value:
* None
*
* Example:
* [vehicle] call r3fadvlog_cargo_fnc_initVehicle
*
* Public: No
*/
#include "script_component.hpp"

params ["_vehicle"];
private _type = typeof _vehicle;
TRACE_2("params", _vehicle,_type);

// do nothing if the class is already initialized
if (_type in GVAR(initializedVehicleClasses_init)) exitWith {};
GVAR(initializedVehicleClasses_init) pushBack _type;

//Turn off ace cago
_vehicle setVariable ['ace_cargo_space', 0];
_vehicle setVariable ['ace_cargo_canLoad', 0];

private _config = configFile >> "CfgVehicles" >> _type;

if (_vehicle getVariable [QGVAR(canTransport), false] == true) then {
  [_vehicle, true, _cargoCapacity] call FUNC(setTransport);
};

