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
 * ["example"] call ace_[module]_fnc_[functionName]
 *
 * Public: [Yes/No]
 */
#include "script_component.hpp"

params ["_vehicle"];
TRACE_1("params", _vehicle);

private _type = typeOf _vehicle;

if ((_object getVariable [QGVAR(hasCargo), getNumber (configFile >> "CfgVehicles" >> _type >> "ace_cargo_hasCargo")]) != 1) exitWith {};
/*TODO: intigrate addExtra function*/

// do nothing if the class is already initialized
if (_type in GVAR(initializedVehicleClasses)) exitWith {};
GVAR(initializedVehicleClasses) pushBack _type;

if (!hasInterface) exitWith {};

TRACE_1("Adding cargo menu action to class", _type);

//adds action to open cargo gui
_myactionCargo = ["R3F_cargo","Cargo","",{_this spawn AdvLog_fnc_seeCargo;},{!R3F_LOG_mutex_local_lock && missionNamespace getVariable ["AdvLog_Endabled", true]},{}] call ace_interact_menu_fnc_createAction;

[_object, 0, ["ACE_MainActions"], _myactionCargo] call ace_interact_menu_fnc_addActionToObject;

/*_myactionCargo = ["R3F_cargoLoad", "Load in vehicle","",{_this spawn AdvLog_fnc_loadSelection;},{!R3F_LOG_mutex_local_lock && R3F_LOG_action_load_valid_selection},{}] call ace_interact_menu_fnc_createAction;

[_object, 0, ["ACE_MainActions"], _myactionCargo] call ace_interact_menu_fnc_addActionToObject;*/

//add vanilla action to load selected object into object acted on
_object addAction [("<t color=""#dddd00"">" + format [STR_R3F_LOG_action_load_selection, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")] + "</t>"), {_this call AdvLog_fnc_loadSelection;}, nil, 10, true, true, "", "!R3F_LOG_mutex_local_lock && R3F_LOG_action_load_valid_selection && (_this distance _target < 6)"];
