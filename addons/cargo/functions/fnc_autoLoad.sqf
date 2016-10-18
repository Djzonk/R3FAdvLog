/*
 * Author: DjZonk
 * Automaticaly adds objects to a another objects cargo
 *
 * Arguments:
 * 0: Vehicle getting object loaded into <OBJECT>
 * 1: Array of of arrays <ARRAY>
 *	0: Object Classname <STRING>
 *	1: Quantity of that object <NUMBER> Default: 1
 *
 * Return Value:
 * No
 *
 * Example:
 * [vehicle, [["classname1", 1], ["classname2", 3]]] call R3FAdvLog_cargo_fnc_autoLoad
 *
 * Public: Yes
 */
#include "script_component.hpp"
params [["_vehicle", objNull],["_autoLoadCargoList", []]];
TRACE_3("params",_vehicle,_autoLoadCargoList);

if (isNull _vehicle) exitWith {ERROR_MSG("Vehicle param is not defined")};
{
	_x params ["_object", ["_quantity", 1]];
	for "_i" from 1 to _quantity do {
		[_object, _vehicle] call FUNC(loadObject);
	};
} count _autoLoadCargoList;
