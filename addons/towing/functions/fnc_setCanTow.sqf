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

// Take ropes
private _displayname = localize LSTRING(Action_Take);
private _statement = {[_this, 10] call FUNC(takeTowRopes)};
private _condition = {[_this,d] call FUNC(canTakeTowRopes)};

private _takeRopes = [QGVAR(takeRopes), _displayname,"",_statement,_condition] call ace_interact_menu_fnc_createAction;
[_vehicle, 0, ["ACE_MainActions"],_takeRopes] call ace_interact_menu_fnc_addActionToObject;


// Put away ropes
_displayname = localize LSTRING(Action_PutAway);
_statement = {[_target, _player] call FUNC(putAwayTowRopes)};
_condition = {
    _existingTowRopes = _target getVariable [QGVAR(towRope),[]];
    (count _existingTowRopes) > 0;
};

private _putAwayRopes = [QGVAR(putAwayRopes), _displayname,"", _statement, _condition] call ace_interact_menu_fnc_createAction;
[_vehicle, 0, ["ACE_MainActions"], _putAwayRopes] call ace_interact_menu_fnc_addActionToObject;


// Take winch control
_displayname = localize LSTRING(Action_WinchControl);
_statement = {
    _player setVariable [QGVAR(towRopeHelper), (_target getVariable [QGVAR(towRopeHelper), objNull])];
    ["", localize LSTRING(Drop), localize LSTRING(Length)] call ace_common_fnc_showMouseHint;
};
_condition = {};

private _winchControl = [QGVAR(winchControl)], localize LSTRING(Action_WinchControl),"", _statement, _condition] call ace_interact_menu_fnc_createAction;
[_vehicle, 0, ["ACE_MainActions"], _winchControl] call ace_interact_menu_fnc_addActionToObject;
