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

params [["_vehicle", objNull]];

if (isNull _vehicle) exitWith {};

// Add and remove cables
_myaction = ["AdvTow_takeRopes", "Attach Emergency Tow Cable","",{_this call AdvLog_fnc_attachECable;},{"AdvLog_TowCable" in (items player) AND !(_target getVariable ["AdvLog_attachedECable", false]) AND _this call AdvLog_fnc_canTakeTowRopes},{}] call ace_interact_menu_fnc_createAction;
[_vehicle, 0, ["ACE_MainActions"], _myaction] call ace_interact_menu_fnc_addActionToObject;

_myaction = ["AdvTow_takeRopes", "Remove Emergency Tow Cable","",{_this call AdvLog_fnc_removeECable;},{_existingTowRopes = (_this select 0) getVariable [QGVAR(towRope),[]]; _target getVariable ["AdvLog_attachedECable", false] AND (count _existingTowRopes) > 0},{}] call ace_interact_menu_fnc_createAction;
[_vehicle, 0, ["ACE_MainActions"], _myaction] call ace_interact_menu_fnc_addActionToObject;


