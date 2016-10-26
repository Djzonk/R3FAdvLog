/*
* Author: DjZonk, S.Crowe
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

disableSerialization;

private _display = uiNamespace getVariable QGVAR(menuDisplay);
if (isNil "_display") exitWith {};

private _cargoList = GVAR(interactionVehicle) getVariable [QGVAR(vehicleCargolist), []];
if (_cargoList isEqualTo []) exitWith {};

private _ctrl = _display displayCtrl 65433;
private _selected = (lbCurSel _ctrl) max 0;
if (count _cargoList <= _selected) exitWith {};

private _object = _cargoList select _selected;

private _objectClass = lbData [_ctrl, _selected];

private _isMovable = _object getVariable [QGVAR(canMove), false];

private _confirmedUnload = true;
if !(_objectClass isKindOf "AllVehicles" && _isMovable) then {
    // unable to move after release message
    _confirmedUnload = [STR_R3F_LOG_action_decharger_deplacable_exceptionnel, "Warning", true, true] call BIS_fnc_GUImessage;
};

if (_confirmedUnload) then {
    closeDialog 0;

    if (_object isKindOf "AllVehicles") then {
        private _emptyPos = [GVAR(interactionVehicle), _objectClass] call ace_common_fnc_findUnloadPosition;
        TRACE_1("findUnloadPosition",_emptyPos);

        if ((count _emptyPos) != 3) exitWith {
            TRACE_4("Could not find unload pos",_vehicle,getPosASL _vehicle,isTouchingGround _vehicle,speed _vehicle);
            if ((!isNull _unloader) && {_unloader == ACE_player}) then {
                [localize LSTRING(Fail_NoUnloadPosition)] call ace_common_fnc_displayTextStructured;
            };
        };
        detach _object;
        [QGVAR(serverUnload), [_item, _emptyPos]] call CBA_fnc_serverEvent;
    } else {
        // TODO: add choice of unloading nearby or carry
        /*TODO: Evaluate a way to avoid dependency*/
        [_object, player, 0, true] call EFUNC(objectmanipulation,moveObject);
    };

    // Removes cargo from vehicle cargo list
    [GVAR(interactionVehicle), _object, false] call FUNC(updateCargoList);
};
