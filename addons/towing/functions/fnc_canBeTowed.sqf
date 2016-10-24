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

params [["_object", objNull]];

if (!(missionNamespace getVariable ["AdvLog_Endabled", true])) exitWith {false};

if (isNull _object) exitWith {false};

_class_heritage = [_object] call AdvLog_fnc_getObjectHeritage;

_can_be_towed = false;
{
        if (_x in R3F_LOG_CFG_can_be_towed) exitWith {_can_be_towed = true;};
} forEach _class_heritage;

_can_be_towed
