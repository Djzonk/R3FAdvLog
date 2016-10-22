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

params ["_player", "_vehicle" ];


_vehicle setVariable [QGVAR(eCableAttached), true, true];

if([_player, _vehicle] call FUNC(canTakeTowRopes)) then {

    if (!local _vehicle) then {
        [_vehicle, clientOwner] remoteExec ["AdvLog_fnc_setOwner", 2];
    };

    _vehicle setVariable ["SA_RopeLength", 5, true];
    [_player,1,["ACE_SelfActions", "ACE_Equipment", 'AdvTow_Drop']] call ace_interact_menu_fnc_removeActionFromObject;

    private ["_existingTowRopes","_hitchPoint","_rope"];
    _existingTowRopes = _vehicle getVariable [QGVAR(towRope),[]];
    if (count _existingTowRopes == 0) then {
        _hitchPoint = [_vehicle] call AdvLog_fnc_getHitchPoints select 1;
        _rope = ropeCreate [_vehicle, _hitchPoint, 5];
        _vehicle setVariable [QGVAR(towRope),[_rope],true];
        _this call AdvLog_fnc_pickupTowRopes;

        _player removeItem "AdvLog_TowCable";
    };

};
