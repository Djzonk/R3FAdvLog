/*
 * Author: DjZonk
 * Enables/Disables the ability for a vehicle to transport cargo.
 *
 * Arguments:
 * 0: vehicle Name <OBJECT>
 * 1: Can Vehicle Transport cargo <BOOL> Optional: default: True
 * 2: Max Cargo Capacity of Vehicle <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle] call r3fadvlog_cargo_fnc_setTransport
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_vehicle", objNull], ["_canTransport", true],"_maxCapacity"];
private _type = typeOf _vehicle;

if ((_canTransport != false) && (isNIl _maxCapacity)) exitWith {
    ERROR("R3FAdvLog_cargo_fnc_setTransport (Param 2 maxCapacity) is not defined")
};

// Update Variables
_object setVariable [QGVAR(canTransport), _canTransport];
_object setVariable [QGVAR(maxCapacity), _maxCapacity];

//if already Transport do nothing
if (_type in GVAR(initializedVehicleClasses)) exitWith {};
GVAR(initializedVehicleClasses) pushBack _type;

TRACE_1("Adding cargo menu/load actions to class", _type);

//Add Cargo Menu Action
private _name = getText (configFile >> "CfgVehicles" >> _type >> "displayName");
private _displayName = format [localize LSTRING(Open_menu), _name];
private _statement = {
    GVAR(interactionVehicle) = _target;
    createDialog QGVAR(menu);
};
private _condition = {
    _target getVariable [QGVAR(canTransport), false];
};

private _menu = [QGVAR(openVehicleCargo), _displayName, "", _statement, _condition] call ace_interact_menu_fnc_createAction;
[_type, 0, ["ACE_MainActions"], _menu] call ace_interact_menu_fnc_addActionToClass;


//Add Load into action
//private _selected = getText (configFile >> "CfgVehicles" >> typeof GVAR(selectedObject) >> "displayName");
//_displayName = format [localize LSTRING(Load_Into), _selected, _name];

_statement = {
    [_player,_target] call FUNC(loadSelection);
};
_condition = {
    _target getVariable [QGVAR(canTransport), false];
};
private _modifierFunction = {
    private _selected = getText (configFile >> "CfgVehicles" >> typeof GVAR(selectedObject) >> "displayName");
    _actionData set [1, format [localize LSTRING(Load_Into), _selected, _name]];
};

private _load = [QGVAR(load), _displayName, "", _statement, _condition, nil, nil, nil, nil, nil, _modifierFunction] call ace_interact_menu_fnc_createAction;
[_vehicle, 0, ["ACE_MainActions"], _load] call ace_interact_menu_fnc_addActionToObject;
