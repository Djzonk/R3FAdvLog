/*
 * Author: DjZonk
 * [Description]
 *
 * Arguments:
 * 0: Vehicle getting cargo loaded into it <OBJECT>
 * 1: Object getting loaded <OBJECT>
 * 2: If adding object to cargo list <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["example"] call R3FAdvLog_cargo_fnc_updateCargoList
 *
 * Public: No
 */
#include "script_component.hpp"
params [["_vehicle", objNull], ["_object", objNull], "_add"];
TRACE_4("params",_vehicle,_object,_add);

private _totalCargoSize = _vehicle getVariable QGVAR(totalCargoSize);
private _objectSize = _object getVariable QGVAR(size);
private _cargoList = _vehicle getVariable [QGVAR(vehicleCargoList), []];

if (_add) then {
    _vehicle setVariable [QGVAR(totalCargoSize), _totalCargoSize + _objectSize, true];
    _vehicle setVariable [QGVAR(vehicleCargoList), _cargoList pushBack _object, true];
} else {
    _vehicle setVariable [QGVAR(totalCargoSize), _totalCargoSize - _objectSize, true];
    _vehicle setVariable [QGVAR(vehicleCargoList), _cargoList deleteAt (_cargoList find _object), true];
};
