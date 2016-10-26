/*
 * Author: DjZonk
 * Initalize Variables for moveable or pushable objects.
 * Called From Init Event Handler.
 *
 * Arguments:
 * 0: Object <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [object] call ace_objectmanipulation_fnc_initObject
 *
 * Public: No
 */
 #include "script_component.hpp"

params ["_object"];

_type = typeOf _object;
TRACE_2("params",_object,_type);

// do nothing if the class is already initialized
if (_type in GVAR(initializedItemClasses_init)) exitWith {};
GVAR(initializedItemClasses_init) pushBack _type;

//Turn off ACE Featues
_object setVariable ['ace_dragging_canCarry', false];
_object setVariable ['ace_dragging_canDrag', false];

if (object getVariable [QGVAR(canMove), getNumber (configFile >> "CfgVehicles" >> _type >> QGVAR(canMove))] == 1) then {
    [_object, true] call FUNC(setMovable);
};

if (_object getVariable [QGVAR(canPush), getNumber (configFile >> "CfgVehicles" >> _type >> QQGVAR(canPush))] == 1) then {
    [_object, true] call FUNC(setPushable);
};
