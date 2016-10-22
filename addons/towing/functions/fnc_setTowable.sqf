/*
* Author: DjZonk
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

_myaction = ["AdvTow_attachRopes", "Attach To Tow Ropes","",{_this call AdvLog_fnc_attachTowRopes;},{_this call AdvLog_fnc_canAttachTowRopes},{}] call ace_interact_menu_fnc_createAction;
[_vehicle, 0, ["ACE_MainActions"], _myaction] call ace_interact_menu_fnc_addActionToObject;