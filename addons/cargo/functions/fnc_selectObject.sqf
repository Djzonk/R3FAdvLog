
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

	// Deselect the object if the player does nothing
	[{
    	params ["_args", "_id"];
    	_args params ["_unit"];

	    if (vehicle player != player || !alive player || (player distance GVAR(selectedObject) > 10) || !isNull EGVAR(objectmanipulation,movingObject)) exitwith {
	        [_id] call CBA_fnc_removePerFrameHandler;
			GVAR(selectedObject) = objNull;
	    };
	}, [_unit], 0] call CBA_fnc_addPerFrameHandler;
