#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

R3F_LOG_CFG_can_tow = missionNamespace getVariable["R3F_LOG_CFG_can_tow", []];
R3F_LOG_CFG_cannot_etow = missionNamespace getVariable["R3F_LOG_CFG_cannot_etow", []];
R3F_LOG_CFG_can_be_towed = missionNamespace getVariable["R3F_LOG_CFG_can_be_towed", []];

#include "initSettings.sqf"

ADDON = true;
