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
* ["example"] call r3fadvlog_[module]_fnc_[functionName]
*
* Public: [Yes/No]
*/
#include "script_component.hpp"

params ["_vehicle"];

_existingTowRopes = _vehicle getVariable ["SA_Tow_Ropes",[]];
_existingVehicle = player getVariable ["SA_Tow_Ropes_Vehicle", objNull];
(vehicle player == player && player distance _vehicle < 10 && (count _existingTowRopes) == 0 && isNull _existingVehicle && missionNamespace getVariable ["AdvLog_Endabled", true] && (vectorMagnitude velocity _vehicle) < 2)
