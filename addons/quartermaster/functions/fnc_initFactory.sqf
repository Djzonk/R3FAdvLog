/*
 * Modified by Sean Crowe, original script by Team ~R3F~
 * please see orginal work @ https://forums.bistudio.com/topic/170033-r3f-logistics/
 *
 * To get a full list of changes please contant me on the biforums under the username S.Crowe
 *
 * Copyright (C) 2014 Team ~R3F~
 *
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
/*
 * Author: [Name of Author(s)]
 * Initialize and configure a creation factory
 *
 * Arguments:
 * 0: _Factory <Object>
 * 1: _credits <Number> (Optinal) Number of Credits, -1 for infinite Credits (Default: -1)
 * 2: _side    <Side>   Depracted	(Optinal) side for which to allow access (default access for all sides)
 * 3: _param3  <Array>  Depracted	(Optinal) list of class names of the authorized categories (white list)
 *												if not known, not all these categories the possible blacklist entry in config_creation_factory.sqf
 *								 				if string of characters "FULL", using the R3F_LOG_CFG_CF_whitelist_full list categories (config_creation_factory.sqf)
 *								 				if string of characters "MEDIUM" Use the list R3F_LOG_CFG_CF_whitelist_medium categories (config_creation_factory.sqf)
 *								 				if chain "LIGHT" characters, use of R3F_LOG_CFG_CF_whitelist_light_categories list (config_creation_factory.sqf)
 *												if class names table CfgVehicles Classes (eg [ "Furniture", "Fortifications"]), use the list provided
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

private ["_factory", "_credits", "_side", "_param3", "_blackwhitelist_categories_toLower"];

_factory = param [0, objNull];
_credits = param [0, -1];

// R?cup?ration du param?tre optionnel de cr?dits
if (count _this > 1 && {!isNil {_this select 1}}) then {
	if (typeName (_this select 1) != "SCALAR") then {
		WARNING(QUOTE(credits parameter passed to QUOTE(init creation factory) is not a number.));
		_this set [1, -1];
	};

	_credits = _this select 1;
} else {_credits = -1};

// credit creation, -1 for infinite credit
if (isNil {_factory getVariable "R3F_LOG_CF_credits"}) then {
	_factory setVariable ["R3F_LOG_CF_credits", _credits, false];
};

if (isNil {_factory getVariable "R3F_LOG_CF_disabled"}) then {
	_factory setVariable ["R3F_LOG_CF_disabled", false, false];
};

_factory setVariable ["R3F_LOG_CF_mem_idx_categorie", 0];
_factory setVariable ["R3F_LOG_CF_mem_idx_object", 0];

//Table containing all created factories
R3F_LOG_CF_liste_factorys pushBack _factory;

//_factory addAction [("<t color=""#ff9600"">" + STR_R3F_LOG_action_ouvrir_factory + "</t>"), {_this call R3F_LOG_FNCT_factory_open_factory}, nil, 5, false, true, "", "!R3F_LOG_mutex_local_lock && R3F_LOG_object_addAction == _target && R3F_LOG_action_valid_open_factory "];

	_action = [QGVAR(openCF), localize LSTRING(Factory_Open),"",{_this spawn R3F_LOG_FNCT_factory_open_factory;},{!R3F_LOG_mutex_local_lock},{}] call ace_interact_menu_fnc_createAction;

	[_factory, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

// Add resell
	//_factory addAction [("<t color=""#dddd00"">" + format ["Return %1", getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")] + "</t>"), {_this call AdvLog_fnc_factoryResell;}, nil, 10, true, true, "", "!R3F_LOG_mutex_local_lock && R3F_LOG_resell_load_valid_selection && (_this distance _target < 6)"];
