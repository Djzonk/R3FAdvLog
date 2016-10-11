/*
 * Author: Crowe
 * when called creates progress bar for object building also makes placing objects abortable.
 *
 * Arguments:
 * 0: Argument Name <TYPE>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["example"] call ace_[module]_fnc_[functionName]
 *
 * Public: No
 */
#include "script_component.hpp"

if (R3F_LOG_mutex_local_lock) then {
	hintC STR_R3F_LOG_mutex_action_en_cours;
} else {
	_object = GVAR(movingObject);
	_costs = [_object] call AdvLog_fnc_buildCosts;

	if (_costs >= 1) then {
		player setVariable [QGVAR(buildingObject), true];

		_handler = [{player playActionNow "MedicOther";}, 7, []] call CBA_fnc_addPerFrameHandler;

		[_costs,
		[_handler],
		{
			[ALIVE_sys_logistics,"updateObject",[GVAR(movingObject)]] call ALIVE_fnc_logistics;
			GVAR(movingObject) = objNull;
			(_this select 0) call CBA_fnc_removePerFrameHandler;
			player switchMove "";
			player setVariable [QGVAR(buildingObject), false];
		},
		{
			(_this select 0) call CBA_fnc_removePerFrameHandler;
			player switchMove "";
			hint localize LSTRING(Aborted);
			player setVariable [QGVAR(buildingObject), false];
		}, format [localize LSTRING(Building), getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")]] call ace_common_fnc_progressBar;

	} else {
		[ALIVE_sys_logistics,"updateObject",[GVAR(movingObject)]] call ALIVE_fnc_logistics;
		GVAR(movingObject) = objNull;
	};

	//Done player playActionNow "MedicOther";
};
