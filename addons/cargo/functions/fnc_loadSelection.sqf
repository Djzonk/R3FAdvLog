/*
* Author: DjZonk
* Triggers loading sequence when loading a selected object
*
* Arguments:
* 0: Player <OBJECT>
* 1: Object <OBJECT>
*
* Return Value:
* Return Name <TYPE>
*
* Example:
* [player, Object] call r3fadvlog_cargo_fnc_loadSelection
*
* Public: No
*/
#include "script_component.hpp"

params ["_player", "_target"];

private _object = _player getVariable [QGVAR(selectedObject), objNull];

[localize LSTRING(load_InProgress)] call ace_common_fnc_displayTextStructured;

switch ([_object,_target] call FUNC(canLoad)) do {
    case 1: {ERROR("R3FAdvLog_cargo_fnc_loadObject Object is Null"); _return = false;};
    case 2: {hint format [localize LSTRING(Fail_Occupied)];_return = false;};
    case 3: {hint localize LSTRING(Fail_Nospace);_return = false;};
    case 4: {hint format [localize LSTRING(Fail_Tofar), getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];_return = false;};
    default {_return = true;};
};
if !(_return) exitWith {};

//Added by crowe to give a little animation
    /*[] spawn {
        player playMove format ["AinvPknlMstpSlay%1Dnon_medic", switch (currentWeapon player) do {
                case "": {"Wnon"};
                case primaryWeapon player: {"Wrfl"};
                case secondaryWeapon player: {"Wlnr"};
                case handgunWeapon player: {"Wpst"};
                default {"Wrfl"};
            }];
    };

sleep 2;*/
/*TODO: TEST is this works*/
switch (currentWeapon player) do {
    case "": {[player,"AinvPknlMstpSlayWnonDnon_medic",0] call ace_common_fnc_doAnimation};
    case primaryWeapon player: {[player,"AinvPknlMstpSlayWrflDnon_medic",0] call ace_common_fnc_doAnimation};
    case secondaryWeapon player: {[player,"AinvPknlMstpSlayWlnrDnon_medic",0] call ace_common_fnc_doAnimation};
    case handgunWeapon player: {[player,"AinvPknlMstpSlayWpstDnon_medic",0] call ace_common_fnc_doAnimation};
    default {[player,"AinvPknlMstpSlayWrflDnon_medic",0] call ace_common_fnc_doAnimation};
};

[_object,_target]call FUNC(loadObject);
_player setVariable [QGVAR(selectedObject), objNull];
