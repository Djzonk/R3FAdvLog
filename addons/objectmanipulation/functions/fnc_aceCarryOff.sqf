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

params ["_object"];

_object = _object param [0, objNull];

if (!(missionNamespace getVariable ["AdvLog_Endabled", true])) exitWith {};

waitUntil {sleep 0.1; !(isNil "R3F_LOG_active")};

_object setVariable ['ace_dragging_canCarry', false];
_object setVariable ['ace_dragging_canDrag', false];
_object setVariable ['ace_cargo_space', 0];
_object setVariable ['ace_cargo_canLoad', 0];
