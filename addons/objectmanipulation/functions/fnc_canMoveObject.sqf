/*
 * Author: [Name of Author(s)]
 * Checks if a Object can be Moved by the player.
 *
 * Arguments:
 * 0: Player doing moving <OBJECT>
 * 1: Object being moved <OBJECT>
 *
 * Return Value:
 * Can player move object. <BOOL>
 *
 * Example:
 * ["example"] call R3FAdvLog_objectmanipulation_fnc_canMoveObject
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_player", "_target"];

if !([_unit, _target, []] call EFUNC(common,canInteractWith)) exitWith {false};

// a static weapon has to be empty for dragging (ignore UAV AI)
if ((typeOf _target) isKindOf "StaticWeapon" && {{(getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "simulation")) != "UAVPilot"} count crew _target > 0}) exitWith {false};
