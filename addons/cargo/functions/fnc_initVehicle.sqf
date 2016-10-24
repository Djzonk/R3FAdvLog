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
TRACE_1("params", _vehicle);
private _type = typeof _vehicle;

// do nothing if the class is already initialized
if (_type in GVAR(initializedVehicleClasses_init)) exitWith {};
GVAR(initializedVehicleClasses_init) pushBack _type;

//Turn off ace cago
_object setVariable ['ace_cargo_space', 0];
_object setVariable ['ace_cargo_canLoad', 0];

private _config = configFile >> "CfgVehicles" >> _type;

if (getNumber _config >> QGVAR(canTransport) == 1 ) then {
    [_vehicle, true, _cargoCapacity] call FUNC(setTransport);
};
/*TODO: Evaluate if below is needed*/
/*//add vanilla action to load selected object into object acted on
_object addAction [("<t color=""#dddd00"">" + format [STR_R3F_LOG_action_load_selection, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")] + "</t>"), {_this call AdvLog_fnc_loadSelection;}, nil, 10, true, true, "", "!R3F_LOG_mutex_local_lock && R3F_LOG_action_load_valid_selection && (_this distance _target < 6)"];*/
