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
 * ["example"] call R3FAdvLog_[module]_fnc_[functionName]
 *
 * Public: [Yes/No]
 */
#include "script_component.hpp"

params ["_vehicle"];
TRACE_1("params", _vehicle);


/*TODO: intigrate addExtra function*/

// do nothing if the class is already initialized
if (_type in GVAR(initializedVehicleClasses)) exitWith {};
GVAR(initializedVehicleClasses) pushBack _type;

private _config = configFile >> "CfgVehicles" >> typeof _vehicle;

if (getNumber _config >> QGVAR(canTransport) == 1 ) then {
    [_vehicle, true, _cargoCapacity] call FUNC(setTransport);
};

/*//add vanilla action to load selected object into object acted on
_object addAction [("<t color=""#dddd00"">" + format [STR_R3F_LOG_action_load_selection, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")] + "</t>"), {_this call AdvLog_fnc_loadSelection;}, nil, 10, true, true, "", "!R3F_LOG_mutex_local_lock && R3F_LOG_action_load_valid_selection && (_this distance _target < 6)"];*/
