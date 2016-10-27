/*
 * Author: DjZonk
 * [Description]
 *
 * Arguments:
 * 0: Object being loaded <OBJECT/STRING>
 * 1: Vehicle object is being loaded into <OBJECT>
 *
 * Return Value:
 * Return true if loading successful <BOOL>
 *
 * Example:
 * ["example"] call r3fadvlog_cargo_fnc_loadObject
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_object", "_vehicle"];
if (_object isEqualType "") then {
    private _newObject = _object createVehicle [0,0,0];
    _object = _newObject;
};
[{
    params ["_object", "_vehicle"];
    if (_object isEqualType objNull) then {
        detach _object;
        _object attachTo [_vehicle,[0,0,-100]];
        ["ace_common_hideObjectGlobal", [_object, true]] call CBA_fnc_serverEvent;
    };
}, [_object,_vehicle]]call CBA_fnc_execNextFrame;

[_vehicle, _object, true] call FUNC(updateCargoList);
