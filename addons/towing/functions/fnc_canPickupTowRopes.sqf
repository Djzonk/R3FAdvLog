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
* ["example"] call r3fadvlog_[module]_fnc_[functionName]
*
* Public: [Yes/No]
*/
#include "script_component.hpp"

(isNull (player getVariable ["SA_Tow_Ropes_Vehicle", objNull]) AND vehicle player == player)