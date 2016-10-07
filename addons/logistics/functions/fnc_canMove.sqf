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

private ["_can_be_moved_by_player"];

params [["_object", objNull]];

if (!(missionNamespace getVariable ["AdvLog_Endabled", true])) exitWith {false};

if (isNull _object) exitWith {false};

_class_heritage = [_object] call AdvLog_fnc_getObjectHeritage;

// Can object be moved by player?
_can_be_moved_by_player = false;
{
	if (_x in R3F_LOG_CFG_can_be_moved_by_player) exitWith {_can_be_moved_by_player = true;};
} forEach _class_heritage;


_can_be_moved_by_player
