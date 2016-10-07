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

private ["_cost"];

params [["_object", objNull]];

if (isNull _object) exitWith {0};

_class_heritage = [_object] call AdvLog_fnc_getObjectHeritage;


_cost = 0;
{
	_idx = R3F_LOG_classes_build_costs find _x;

	if (_idx != -1) then
	{
		_cost = (R3F_LOG_CFG_build_costs select _idx) select 1;
	};

} forEach _class_heritage;

_cost
