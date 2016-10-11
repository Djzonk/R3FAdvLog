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

//Initalize Variables
_object setVariable [QGVAR(transportedBy), objNull,];
_object setVariable [QGVAR(movedBy), objNull,];

if (GETVAR(_object,QGVAR(canMove), false) == true) then {
    [_object, true] call FUNC(setMovable);
};

if (GETVAR(_object,QGVAR(canPush), false) == true) then {
    [_object, true] call FUNC(setPushable);
};
