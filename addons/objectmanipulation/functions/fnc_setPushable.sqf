/*
 * Author: DjZonk
 * Enables/Disables the ability to Push the object
 *
 * Arguments:
 * 0: Any Object <OBJECT>
 * 1: true to enable, false to disable <BOOL> Default: true
 *
 * Return Value:
 * None
 *
 * Example:
 * ["object", true] call R3FAdvLog_objectmanipulaion_fnc_setPushable
 *
 * Public: Yes
 */
#include "script_component.hpp"

params [["_object", objNull], ["_enablePush", true]];
private _type = typeOf _object;

// Sets/Updates Variable
_object setVariable [QGVAR(canPush), _enablePush];

// do nothing if the class is already initialized
if (_type in GVAR(initializedItemClasses_push)) exitWith {};
GVAR(initializedItemClasses_push) pushBack _type;


private _name = getText (configFile >> "CfgVehicles" >> _type >> "displayName");
private _displayname = format [localize LSTRING(Push), _name];
private _icon = "";
private _statement = {_this call ace_interaction_fnc_push};
private _condition = {[_target] call FUNC(canPush)};

private _action = [QGVAR(push), _displayname, _icon, _statement, _condition] call ace_interact_menu_fnc_createAction;

[_type, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToClass;
