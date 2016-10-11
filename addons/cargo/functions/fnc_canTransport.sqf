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
private ["_class_heritage, _can_transport_cargo, _can_transport_cargo_cout"];

params [["_object", objNull]];

/*TODO: Intigrate selectObject condition into*/

if (!(missionNamespace getVariable ["AdvLog_Endabled", true])) exitWith {[false, 0]};

if (isNull _object) exitWith {["Error: Object is Null"] call AdvLog_fnc_globalMessage; [false, 0]};

_class_heritage = [_object] call AdvLog_fnc_getObjectHeritage;

// Can it hold cargo?
_can_transport_cargo = false;
_can_transport_cargo_cout = 0;
{
	_idx = R3F_LOG_transporter_classes find _x;
	if (_idx != -1) exitWith
	{
		_can_transport_cargo = true;
		_can_transport_cargo_cout = R3F_LOG_CFG_can_transport_cargo select _idx select 1;
	};
} forEach _class_heritage;

// Cargo capacity zero
if (_can_transport_cargo_cout <= 0) then {_can_transport_cargo = false;};


[_can_transport_cargo, _can_transport_cargo_cout]
