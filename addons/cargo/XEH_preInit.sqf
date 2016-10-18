#include "script_component.hpp"

ADDON = false;
LOG(MSG_INIT);

#include "XEH_PREP.hpp"

GVAR(initializedItemClasses) = [];
GVAR(initializedItemClasses_init) = [];
GVAR(initializedVehicleClasses_init) = [];
GVAR(initializedVehicleClasses) = [];

#include "initSettings.sqf"

ADDON = true;
