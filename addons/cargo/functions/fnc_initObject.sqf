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
 * ["example"] call ace_[module]_fnc_[functionName]
 *
 * Public: [Yes/No]
 */
 #include "script_component.hpp"

params ["_object"];
_type = typeOf _object;
TRACE_2("params",_object,_type);

// do nothing if the class is already initialized
if (_type in GVAR(initializedItemClasses_init)) exitWith {};
GVAR(initializedItemClasses_init) pushBack _type;

//Turn off ace cago
_object setVariable ['ace_cargo_space', 0];
_object setVariable ['ace_cargo_canLoad', 0];

if (GETVAR(_object,QGVAR(canBeTransported), false) == true) then {
    [_object, true] call FUNC(setTransportable);
};

if (GETVAR(_object,QGVAR(canTransport), false) == true) then {
    [_object, true] call FUNC(setTransport);
};
