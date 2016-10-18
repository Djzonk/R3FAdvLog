/*
* Author: DjZonk, S.Crowe, r3f team
* control unload process
*
* Arguments:
* None
*
* Return Value:
* None
*
* Example:
* [] call r3fadvlog_cargo_fnc_unloadObject
*
* Public:  No
*/
#include "script_component.hpp"
#include "\z\r3fadvlog\addons\logistics\dlgDefines.hpp"

disableSerialization;

private _display = uiNamespace getVariable QGVAR(menuDisplay);
if (isNil "_display") exitWith {};

private _cargoList = GVAR(interactionVehicle) getVariable [QGVAR(vehicleCargolist), []];
if (_cargoList isEqualTo []) exitWith {};

private _ctrl = _display displayCtrl 65433
private _selected = (lbCurSel _ctrl) max 0;
if (count _cargoList <= _selected) exitWith {};

private _object = _cargoList select _selected;

private _objectClass = lbData [_ctrl, _selected];

private _isMovable = _object getVariable [QGVAR(canMove), false];
if (!(_objectClass isKindOf "AllVehicles") && !_isMovable) then {
	// unable to move after release message
	private _unloadConfirmed = [STR_R3F_LOG_action_decharger_deplacable_exceptionnel, "Warning", true, true] call BIS_fnc_GUImessage;
} else {
	_unloadConfirmed = true;
};

if (_unloadConfirmed) then {
	closeDialog 0;

	if (_object isKindOf "AllVehicles" && !_isMovable) then {
	    private _emptyPos = [GVAR(interactionVehicle), _objectClass] call Ace_common_fnc_findUnloadPosition;
		TRACE_1("findUnloadPosition",_emptyPos);

		if ((count _emptyPos) != 3) exitWith {
			TRACE_4("Could not find unload pos",_vehicle,getPosASL _vehicle,isTouchingGround _vehicle,speed _vehicle);
			if ((!isNull _unloader) && {_unloader == ACE_player}) then {
				[localize LSTRING(Fail_NoUnloadPosition)] call ace_common_fnc_displayTextStructured;
			};
		};
		detach _object;
		[QGVAR(serverUnload), [_item, _emptyPos]] call CBA_fnc_serverEvent;
	};

	if (!(_object isKindOf "AllVehicles") || _isMovable) then {
		/*TODO: Evaluate a way to avoid dependency*/
		[_object, player, 0, true] call EFUNC(objectmanipulation,moveObject);
	};

	//Update variables after unload
	_object setVariable [QGVAR(transportedBy), objNull, true];
	// Removes cargo from vehicle cargo list
	_cargoList deleteAt (_cargoList find _object);
	GVAR(interactionVehicle) setVariable [QGVAR(vehicleCargoList), _cargoList, true];
	// updated total Cargo size
	_totalCargoSize = GVAR(interactionVehicle) getVariable QGVAR(totalCargoSize);
	_objectSize = _object getVariable QGVAR(size);
	GVAR(interactionVehicle) setVariable [QGVAR(totalCargoSize), _totalCargoSize - _objectSize, true];

};
