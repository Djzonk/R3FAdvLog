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

params [["_factory", objNull]];

if (isNull _factory) exitWith {[]};

_factoryData = _factory getVariable ["R3F_CF_local_factory", R3F_CF_global_factory];

(_factoryData param [0, []])
