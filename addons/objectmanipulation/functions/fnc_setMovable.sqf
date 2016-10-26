/*
 * Author: DjZonk
 * Enables/Disables the ability to Move the object
 *
 * Arguments:
 * 0: Any Object <OBJECT>
 * 1: true to enable, false to disable <BOOL> Default: True
 *
 * Return Value:
 * None
 *
 * Example:
 * ["object", true] call R3FAdvLog_objectmanipulaion_fnc_setMovable
 *
 * Public: Yes
 */
#include "script_component.hpp"

params ["_object", ["_enableMove", true]];
private _type = typeOf _object;

// Sets/Updates Variable
_object setVariable [QGVAR(canMove), _enableMove];

// do nothing if the class is already initialized
if (_type in GVAR(initializedItemClasses)) exitWith {};
GVAR(initializedItemClasses) pushBack _type;

//Initalize variables
_object setVariable [QGVAR(movedBy), objNull];

private _name = getText (configFile >> "CfgVehicles" >> _type >> "displayName");
private _displayname = format [localize LSTRING(Move), _name];
private _icon = "z\ace\addons\dragging\UI\icons\box_carry.paa";
private _statement = {_this spawn FUNC(moveObj);};
private _condition = {[_player, _target] call FUNC(canMoveObject)};

private _action = [QGVAR(move), _displayname, _icon, _statement, _condition] call ace_interact_menu_fnc_createAction;

[_type, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToClass;
