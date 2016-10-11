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
 * ["example"] call ace_[module]_fnc_[functionName]
 *
 * Public: [Yes/No]
 */
#include "script_component.hpp"
#include "\z\r3fadvlog\addons\logistics\dlgDefines.hpp"

 if (R3F_LOG_mutex_local_lock) then {
	hintC STR_R3F_LOG_mutex_action_en_cours;
} else {
	R3F_LOG_mutex_local_lock = true;

	private ["_vehicle", "_objects_charges", "_type_object_a_decharger", "_object", "_actionConfirmed", "_isMovable"];

	_vehicle = uiNamespace getVariable "R3F_LOG_dlg_CV_transporteur";
	_objects_charges = _vehicle getVariable ["R3F_LOG_objects_charges", []];

	if (lbCurSel R3F_LOG_IDC_dlg_CV_liste_contenu == -1) exitWith {R3F_LOG_mutex_local_lock = false;};

	_type_object_a_decharger = lbData [R3F_LOG_IDC_dlg_CV_liste_contenu, lbCurSel R3F_LOG_IDC_dlg_CV_liste_contenu];

	_object = objNull;
	{
		if (typeOf _x == _type_object_a_decharger) exitWith {_object = _x;};
	} forEach _objects_charges;

	_isMovable = [_object] call EFUNC(objectmanipulation,canMoveObject);


	if (!(_type_object_a_decharger isKindOf "AllVehicles") && !_isMovable) then {
		_actionConfirmed = [STR_R3F_LOG_action_decharger_deplacable_exceptionnel, "Warning", true, true] call BIS_fnc_GUImessage;
	} else {
		_actionConfirmed = true;
	};

	if (_actionConfirmed) then {
		closeDialog 0;


		if !(isNull _object) then {

			// On m?morise sur le r?seau le nouveau contenu du transporteur (c?d avec cet objet en moins)
			_objects_charges = _vehicle getVariable ["R3F_LOG_objects_charges", []];
			_objects_charges = _objects_charges - [_object];
			_vehicle setVariable ["R3F_LOG_objects_charges", _objects_charges, true];

			_object setVariable [QGVAR(transportedBy), objNull, true];

			if (!(_object isKindOf "AllVehicles") || _isMovable) then {
				R3F_LOG_mutex_local_lock = false;
				[_object, player, 0, true] spawn AdvLog_fnc_moveObj;
			} else {
				private ["_bbox_dim", "_pos_degagee", "_rayon"];

				systemChat STR_R3F_LOG_action_decharger_en_cours;

				_bbox_dim = (vectorMagnitude (boundingBoxReal _object select 0)) max (vectorMagnitude (boundingBoxReal _object select 1));

				sleep 1;

				// Finding an open position (the radius is gradually increased until you find a position)
				for [{_rayon = 5 max (2*_bbox_dim); _pos_degagee = [];}, {count _pos_degagee == 0 && _rayon <= 30 + (8*_bbox_dim)}, {_rayon = _rayon + 10 + (2*_bbox_dim)}] do {
					_pos_degagee = [
						_bbox_dim,
						_vehicle modelToWorld [0, if (_vehicle isKindOf "AllVehicles") then {(boundingBoxReal _vehicle select 0 select 1) - 2 - 0.3*_rayon} else {0}, 0],
						_rayon,
						100 min (5 + _rayon^1.2)
					] call R3F_LOG_FNCT_3D_tirer_position_degagee_sol;
				};

				if (count _pos_degagee > 0) then {
					detach _object;
					_object setPos _pos_degagee;
					_object setVectorDirAndUp [[-cos getDir _vehicle, sin getDir _vehicle, 0] vectorCrossProduct surfaceNormal _pos_degagee, surfaceNormal _pos_degagee];
					_object setVelocity [0, 0, 0];

					sleep 0.4; // Because the new position is not taken into account INSTANTANEOUSLY

					// If the object has been created far enough, we indicate its relative position
					if (_object distance _vehicle > 40) then {
						systemChat format [STR_R3F_LOG_action_decharger_fait + " (%2)",
							getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName"),
							format ["%1m %2deg", round (_object distance _vehicle), round ([_vehicle, _object] call BIS_fnc_dirTo)]
						];
					} else {
						systemChat format [STR_R3F_LOG_action_decharger_fait, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
					};
					R3F_LOG_mutex_local_lock = false;
                // Si ?chec recherche position d?gag?e, on d?charge l'objet comme un d?pla?able
				} else {
					systemChat "WARNING : no free position found.";

					R3F_LOG_mutex_local_lock = false;
					[_object, player, 0, true] spawn AdvLog_fnc_moveObj;
				};
			};
		} else {
			hintC STR_R3F_LOG_action_decharger_deja_fait;
			R3F_LOG_mutex_local_lock = false;
		};
	} else {
		R3F_LOG_mutex_local_lock = false;
	};
};
