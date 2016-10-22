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
* Public: No
*/
#include "script_component.hpp"
params ["", "_amount"];

private _helper = ACE_player getVariable [QGVAR(towRopeHelper), objNull];

if (isNull _helper) exitWith {};

private _rope = getVariable _helper [QGVAR(towRope), objNull];
private _ropeLength = ropeLength _rope;

if (_amount > 0) then {
    // Extend Rope
    ropeUnwind [_rope, 1, (_ropeLength + 1) min QGVAR(maxTowRopeLength), true];
} else {
    // Retract
    ropeUnwind [_rope, 1, (_ropeLength + 1) max 1, true];
};