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

private ["_objects_charges", "_currentLoad", "_maxLoad"];

params [["_transporter", objNull]];

_objects_charges = _transporter getVariable ["R3F_LOG_objects_charges", []];

// Get amount of cargo in vehicle
_currentLoad = 0;
{
	_currentLoad = _currentLoad + (([_x] call AdvLog_fnc_canBeTransported) param [1, 0]);

} forEach _objects_charges;

// Get maximum amount of cargo held

_maxLoad = ([_transporter] call AdvLog_fnc_canTransport) param [1, 0];

[_currentLoad, _maxLoad]
