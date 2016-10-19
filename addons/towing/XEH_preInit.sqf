#include "script_component.hpp"

ADDON = false;
LOG(MSG_INIT);

#include "XEH_PREP.hpp"

GVAR(canTow) = missionNamespace getVariable[QGVAR(canTow), []];
GVAR(cannotETOW) = missionNamespace getVariable[QGVAR(cannotETOW), []];
GVAR(canBeTowed) = missionNamespace getVariable[QGVAR(canBeTowed), []];

#include "initSettings.sqf"

ADDON = true;
