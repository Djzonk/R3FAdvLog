/*
 * Author: DjZonk
 * Determines if a Object can be pushed by the player
 *
 * Arguments:
 * 0: target object <OBJECT>
 *
 * Return Value:
 * IF can push object <BOOL>
 *
 * Example:
 * ["example"] call ace_[module]_fnc_[functionName]
 *
 * Public: No
 */
#include "script_component.hpp"

params ["_target"];

alive _target &&
{vectorMagnitude velocity _target < 3}
