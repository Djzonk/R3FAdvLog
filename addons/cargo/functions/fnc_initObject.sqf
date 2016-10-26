/*
 * Author: DjZonk
 * adds cargo actions to objects called by CfgEventHandlers
 *
 * Arguments:
 * 0: object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [object] call r3fadvlog_cargo_fnc_initObject
 *
 * Public: No
 */
 #include "script_component.hpp"

params ["_object"];
private _type = typeOf _object;
TRACE_2("params",_object,_type);

// do nothing if the class is already initialized
if (_type in GVAR(initializedItemClasses_init)) exitWith {};
GVAR(initializedItemClasses_init) pushBack _type;

if (_object getVariable [QGVAR(canBeTransported), getNumber (configFile >> "CfgVehicles" >> _type >> QGVAR(canBeTransported))] == 1) then {
    [_object, true] call FUNC(setTransportable);
};

if (_object getVariable [QGVAR(canTransport), getNumber (configFile >> "CfgVehicles" >> _type >> QGVAR(canTransport))] == 1) then {
    [_object, true] call FUNC(setTransport);
};
