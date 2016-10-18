/**
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

_this spawn

{
	params [["_vehicle", objNull],["_autoLoadCargoList", []]];

	private ["_chargement", "_cout_chargement_object"];
	private ["_objectOrClass", "_object", "_class", "_bbox", "_bbox_dim", "_pos_degagee", "_fonctionnalites", "_i"];

	private _maxCapacity = _vehicle getVariable [QGVAR(maxCapacity), 0];
	private _totalCargoSize = _vehicle getVariable [QGVAR(totalCargoSize), 0];
	private _cargoList = _vehicle getVariable [QGVAR(vehicleCargoList), []];

	// For each item in the list to load
	{
		_x params [_object, [_quantity, 1]];
		if (typeName _x == "ARRAY" && {count _x > 0}) then {
			_objectOrClass = _x select 0;

			if (typeName _objectOrClass == "STRING" && count _x > 1) then {
				_quantity = _x select 1;
			} else {
				_quantity = 1;
			};
		} else {
			_objectOrClass = _x;
			_quantity = 1;
		};

		if (typeName _objectOrClass == "STRING") then {
			_class = _objectOrClass;
			_bbox = [_class] call R3F_LOG_FNCT_3D_get_bounding_box_depuis_classname;
			_bbox_dim = (vectorMagnitude (_bbox select 0)) max (vectorMagnitude (_bbox select 1));

			// Recherche d'une position d?gag?e. Les v?hicules doivent ?tre cr?? au niveau du sol sinon ils ne peuvent ?tre utilis?s.
			if (_class isKindOf "AllVehicles") then {
				_pos_degagee = [_bbox_dim, getPos _vehicle, 200, 50] call R3F_LOG_FNCT_3D_tirer_position_degagee_sol;
			} else {
				_pos_degagee = [] call R3F_LOG_FNCT_3D_tirer_position_degagee_ciel;
			};

			if (count _pos_degagee == 0) then {_pos_degagee = getPosATL _vehicle;};
		} else {
			_class = typeOf _objectOrClass;
		};

		_fonctionnalites = [_class] call AdvLog_fnc_canBeTransportedClass;
		_cout_chargement_object = _fonctionnalites param [1, 0];

		// S'assurer que le type d'objet ? charger est transportable En: Ensure that the object type? load is transportable
		if !(_fonctionnalites param[0, false]) then {
			diag_log format ["[Auto-load ""%1"" in ""%2""] : %3",
				getText (configFile >> "CfgVehicles" >> _class >> "displayName"),
				getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName"),
				"The object is not a transporable class."];

			systemChat format ["[Auto-load ""%1"" in ""%2""] : %3",
				getText (configFile >> "CfgVehicles" >> _class >> "displayName"),
				getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName"),
				"The object is not a transporable class."];
		} else {
			for [{_i = 0}, {_i < _quantity}, {_i = _i+1}] do {
				// Si l'objet ? charger est donn? en tant que nom de classe, on le cr?e
				if (typeName _objectOrClass == "STRING") then {
					// Recherche d'une position d?gag?e. Les v?hicules doivent ?tre cr?? au niveau du sol sinon ils ne peuvent ?tre utilis?s.
					if (_class isKindOf "AllVehicles") then {
						_object = _class createVehicle _pos_degagee;
						_object setVectorDirAndUp [[-cos getDir _vehicle, sin getDir _vehicle, 0] vectorCrossProduct surfaceNormal _pos_degagee, surfaceNormal _pos_degagee];
						_object setVelocity [0, 0, 0];
					} else {
						_object = _class createVehicle _pos_degagee;
					};
				} else {
					_object = _objectOrClass;
				};

				if (!isNull _object) then {
					// V?rifier qu'il n'est pas d?j? transport?
					if (isNull (_object getVariable ["R3F_LOG_is_transported_by", objNull]) &&
						(isNull (_object getVariable ["R3F_LOG_is_moved_by", objNull]) || (!alive (_object getVariable ["R3F_LOG_is_moved_by", objNull])) || (!isPlayer (_object getVariable ["R3F_LOG_is_moved_by", objNull])))
					) then {
						if (isNull (_object getVariable ["R3F_LOG_remorque", objNull])) then {
							// Si l'objet loge dans le v?hicule
							if (_totalCargoSize + _cout_chargement_object <= _maxCapacity) then {
								_totalCargoSize = _totalCargoSize + _cout_chargement_object;
								_cargoList pushBack _object;

								_object setVariable ["R3F_LOG_is_transported_by", _vehicle, true];
								_object attachTo [R3F_LOG_PUBVAR_point_attache, [] call R3F_LOG_FNCT_3D_tirer_position_degagee_ciel];
							} else {
								diag_log format ["[Auto-load ""%1"" in ""%2""] : %3",
									getText (configFile >> "CfgVehicles" >> _class >> "displayName"),
									getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName"),
									STR_R3F_LOG_action_charger_pas_assez_de_place];

								systemChat format ["[Auto-load ""%1"" in ""%2""] : %3",
									getText (configFile >> "CfgVehicles" >> _class >> "displayName"),
									getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName"),
									STR_R3F_LOG_action_charger_pas_assez_de_place];

								if (typeName _objectOrClass == "STRING") then {
									deleteVehicle _object;
								};
							};
						} else {
							diag_log format [STR_R3F_LOG_object_remorque_en_cours, getText (configFile >> "CfgVehicles" >> _class >> "displayName")];
							systemChat format [STR_R3F_LOG_object_remorque_en_cours, getText (configFile >> "CfgVehicles" >> _class >> "displayName")];
						};
					} else {
						diag_log format [STR_R3F_LOG_object_in_course_transport, getText (configFile >> "CfgVehicles" >> _class >> "displayName")];
						systemChat format [STR_R3F_LOG_object_in_course_transport, getText (configFile >> "CfgVehicles" >> _class >> "displayName")];
					};
				};
			};
		};
	} forEach _autoLoadCargoList;

	// On m?morise sur le r?seau le nouveau contenu du v?hicule
	_vehicle setVariable ["R3F_LOG_cargoList", _cargoList, true];
};
