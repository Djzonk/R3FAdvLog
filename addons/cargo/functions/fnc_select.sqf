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

if (R3F_LOG_mutex_local_lock) then
{
	hintC STR_R3F_LOG_mutex_action_en_cours;
}
else
{
	R3F_LOG_mutex_local_lock = true;

	R3F_LOG_object_selectionne = _this select 0;

	R3F_LOG_action_load_valid_selection = true;

	systemChat format [STR_R3F_LOG_action_selectionner_object_fait, getText (configFile >> "CfgVehicles" >> (typeOf R3F_LOG_object_selectionne) >> "displayName")];

	// Deselect the object if the player does nothing
	[] spawn
	{
		while {!isNull R3F_LOG_object_selectionne} do
		{
			if (!alive player) then
			{
				R3F_LOG_object_selectionne = objNull;
			}
			else
			{
				if (vehicle player != player || (player distance R3F_LOG_object_selectionne > 10) || !isNull R3F_LOG_player_moves_object) then
				{

					R3F_LOG_object_selectionne = objNull;
				};
			};

			sleep 0.2;
		};

		R3F_LOG_action_load_valid_selection = false;
	};

	R3F_LOG_mutex_local_lock = false;
};
