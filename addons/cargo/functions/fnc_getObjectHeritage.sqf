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

params [["_object", objNull]];

if (isNull _object) exitWith {false};

_class = typeOf _object;

// Get the heritage of the object
_class_heritage = [];
for [
	{_config = configFile >> "CfgVehicles" >> _class},
	{isClass _config},
	{_config = inheritsFrom _config}
] do
{
	_class_heritage pushBack (toLower configName _config);
};

_class_heritage
