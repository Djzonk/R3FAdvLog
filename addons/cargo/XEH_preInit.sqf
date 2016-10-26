#include "script_component.hpp"

ADDON = false;
LOG(MSG_INIT);

#include "XEH_PREP.hpp"

//Turn off ace cago
["ace_cargo_enable", false, true, true] call ace_common_fnc_setSetting;
LOG("Disabling ace cargo");

GVAR(initializedItemClasses) = [];
GVAR(initializedItemClasses_init) = [];
GVAR(initializedVehicleClasses_init) = [];
GVAR(initializedVehicleClasses) = [];

#include "initSettings.sqf"

ADDON = true;
