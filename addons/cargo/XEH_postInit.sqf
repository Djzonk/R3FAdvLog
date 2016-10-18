#include "script_component.hpp"

if (isServer) then {
    if !(["ace_repair"]call ace_common_fnc_isModLoaded) exitWith {};
    LOG("Adding Spare parts");

    ["Car", "Init", {[_this select 0, [["ACE_Wheel"]]] call FUNC(autoLoad)}, true, [], true] call CBA_fnc_addClassEventHandler;
    ["Tank", "Init", {[_this select 0, 1, [["ACE_Track"]]] call FUNC(autoLoad)}, true, [], true] call CBA_fnc_addClassEventHandler;
};

[QGVAR(serverUnload), {
    params ["_item", "_emptyPos"];

    _item hideObjectGlobal false;
    _item setPosASL (AGLtoASL _emptyPos);
}] call CBA_fnc_addEventHandler;
