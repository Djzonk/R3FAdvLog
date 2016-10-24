/*
* Author: DjZonk
* [Description]
*
* Arguments:
* 0: Player <OBJECT>
* 1: Vehicle <OBJECT>
* 2: Helper <OBJECT>
*
* Return Value:
* Return Name <TYPE>
*
* Example:
* ["example"] call r3fadvlog_[module]_fnc_[functionName]
*
* Public: No
*/
#include "script_component.hpp"

params [["_player", objNull], ["_vehicle", objNull], ["_helper", objNull]];

if (!local _vehicle) then {// TODO: change to ace claim
    [_vehicle, clientOwner] remoteExec ["AdvLog_fnc_setOwner", 2];
};

if (isNull _helper) then {// taking from towing Vehicle
    private _helper = GVAR(pickUpHelper) createVehicle position _player;
    _helper attachTo [_player, [-0.02,0.05,-0.12], "righthandmiddle1"];

    // create rope attach to helper
    private _hitchPoint = [_vehicle] call FUNC(getHitchPoints) select 1;
    private _rope = ropeCreate [_vehicle, _hitchPoint, _helper, [0,0,0], 10];

    _helper setVariable [QGVAR(towRopeOwner), _vehicle, true];
    _helper setVariable [QGVAR(towRope), _rope, true];

    _vehicle setVariable [QGVAR(towRopeHelper), _helper, true];

    _player setVariable [QGVAR(towRopeHelper), _helper];

    [
        "",
        localize LSTRING(Drop),
        localize LSTRING(Length)
    ] call ace_common_fnc_showMouseHint;

} else { // taking from ground or towed Vehicle

    _helper attachTo [_player, [-0.02,0.05,-0.12], "righthandmiddle1"];
    _player setVariable [QGVAR(towRopeHelper), _helper];

    [
        "",
        localize LSTRING(Drop),
        localize LSTRING(Length)
    ] call ace_interaction_fnc_showMouseHint;
};
