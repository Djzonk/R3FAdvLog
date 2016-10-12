#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

GVAR(initializedItemClasses) = [];
GVAR(initializedVehicleClasses) = [];

//Initalize Global Variables
GVAR(canTransport) = [];
GVAR(canBeTransported) = [];
GVAR(canBeMoved) = [];
GVAR(canBePushed) = [];
GVAR(cost) = [];

#include "initSettings.sqf"

ADDON = true;
