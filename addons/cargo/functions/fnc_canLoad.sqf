/*
 * Author: DjZonk
 * Check if object can load into another object.
 *
 * Arguments:
 * 0: Object being loaded <OBJECT>
 * 1: Vehicle object is is getting loaded into <OBJECT>
 *
 * Return Value:
 * Return Number of failure is there is one if no failure returns nothing.
 *
 * Example:
 * [_object,_vehicle] call R3FAdvLog_cargo_fnc_canLoad
 *
 * Public: No
 */
#include "script_component.hpp"
params ["_object", "_vehicle"];

if !(_object isEqualType objNull) exitWith {};

private _maxCapacity = _vehicle getVariable QGVAR(maxCapacity);
private _totalCargoSize = _vehicle getVariable QGVAR(totalCargoSize);
private _objectSize = _object getVariable QGVAR(size);

if (isNull _object) exitWith {1};
// if object is occupied
if !(count crew _object == 0 || getNumber (configFile >> "CfgVehicles" >> (typeOf _object) >> "isUav") == 1) exitWith {2};
// if there is enough room in the vehicle
if (_totalCargoSize + _objectSize > _maxCapacity) exitWith {3};
// if the object is within 15 meters
if (_object distance _vehicle > 15) exitWith {4};
