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
 * ["example"] call R3FAdvLog_cargo_fnc_loadObject
 *
 * Public: [Yes/No]
 */
#include "script_component.hpp"

params ["_object", "_vehicle"];

switch ([_object,_vehicle]call FUNC(canLoad)) do {
    case 1: {ERROR("R3FAdvLog_cargo_fnc_loadObject Object is Null"); _return = false;};
	case 2: {hint format [localize LSTRING(Fail_Occupied)];_return = false;};
	case 3: {hint localize LSTRING(Fail_Nospace);_return = false;};
	case 4: {hint format [localize LSTRING(Fail_Tofar), getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];_return = false;};
	default {_return = true;};
};
if (_return == false) exitWith {_return};

// updates vehicleCargoList with new cargo
private _cargoList = _vehicle getVariable [QGVAR(vehicleCargoList), []];
_cargoList pushBack _object;
_vehicle setVariable [QGVAR(vehicleCargoList), _cargoList, true];

_object setVariable [QGVAR(transportedBy), _vehicle, true];

// updates totalCargoSize with size of new cargo
private _totalCargoSize = _target getVariable QGVAR(totalCargoSize);
private _objectSize = _object getVariable QGVAR(size);
_vehicle setVariable [QGVAR(totalCargoSize), _totalCargoSize + _objectSize, true];

if (!isNull attachedTo _object) then {
	detach _object
};
_object attachTo [_vehicle,[0,0,-100]];
["ace_common_hideObjectGlobal", [_item, true]] call CBA_fnc_serverEvent;

_return
