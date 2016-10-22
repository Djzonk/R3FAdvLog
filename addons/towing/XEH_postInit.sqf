#include "script_component.hpp"

// Exit on HC
if (!hasInterface) exitWith {};

//Display handlers
["MouseZChanged", {_this call FUNC(handleScrollWheel)}] call CBA_fnc_addDisplayHandler;
["MouseButtonDown", {_this call FUNC(dropTowRopes)}] call CBA_fnc_addDisplayHandler;