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
 * ["example"] call ace_[module]_fnc_[functionName]
 *
 * Public: [Yes/No]
 */
#include "script_component.hpp"
#include "\z\r3fadvlog\addons\logistics\dlgDefines.hpp"

disableSerialization; // A cause des displayCtrl

private ["_dlg_liste_objects"];

_dlg_liste_objects = findDisplay R3F_LOG_IDD_dlg_liste_objects;

(uiNamespace getVariable "R3F_LOG_dlg_LO_factory") setVariable ["R3F_LOG_CF_mem_idx_categorie", lbCurSel (_dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_liste_categories)];
(uiNamespace getVariable "R3F_LOG_dlg_LO_factory") setVariable ["R3F_LOG_CF_mem_idx_object", lbCurSel (_dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_liste_objects)];
