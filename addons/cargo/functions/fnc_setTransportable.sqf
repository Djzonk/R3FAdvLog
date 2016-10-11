/*
 * Author: DjZonk
 * Enables/Disables the ability to transport the object
 *
 * Arguments:
 * 0: Any Object <OBJECT>
 * 1: Enable/disable (Default True) <BOOL> Optional:
 * 2: Size of the object (Default 1) <NUMBER>
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
params [["_object", objNull], ["_canBeTransported", true], ["_size",1]];
private _type = typeOf _object;

// Update Variables
_object setVariable [QGVAR(canBeTransported), _canBeTransported];
_object setVariable [QGVAR(size), _size];

//if already Transportable do nothing
if (_type in GVAR(initializedItemClasses)) exitWith {};
GVAR(initializedItemClasses) pushBack _type;

//Add load action
private _name = getText (configFile >> "CfgVehicles" >> _type >> "displayName");
private _displayName = format [localize LSTRING(Load_Select), _name];
private _icon = "z\ace\addons\cargo\UI\Icon_load.paa";
private _statement = {
    _player setVariable [QGVAR(selectedObject), _target];
    [format [localize LSTRING(Load_Destination), _name]] call ace_common_fnc_displayTextStructured;
};
private _condition = {
    _target getVariable [QGVAR(canBeTransported), false] ||
    [_player,_target] call ace_common_fnc_canInteractWith;
};

_load = [QGVAR(load),_displayName,_icon,_statement,_condition] call ace_interact_menu_fnc_createAction;

[_type, 0, ["ACE_MainActions"], _load] call ace_interact_menu_fnc_addActionToClass;
