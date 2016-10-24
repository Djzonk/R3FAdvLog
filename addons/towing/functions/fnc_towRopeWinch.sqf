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
params ["_target", "_player"];

_player setVariable [QGVAR(towRopeHelper), (_target getVariable [QGVAR(towRopeHelper), objNull])];

[
    "",
    localize LSTRING(Drop),
    localize LSTRING(Length)
] call ace_common_fnc_showMouseHint;
