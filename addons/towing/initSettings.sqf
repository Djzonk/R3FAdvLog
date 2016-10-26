[
    QGVAR(maxTowRopeLength),
    "SLIDER",
    LSTRING(MaxRopeLength_Displayname),
    LSTRING(SettingsCategory),
    [0,50,25,0],
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(maxTrainLength),
    "SLIDER",
    [LSTRING(MaxTrainLength_Displayname), LSTRING(MaxTrainLength_Tooltip)],
    LSTRING(SettingsCategory),
    [1,10,2,0],
    true
] call CBA_Settings_fnc_init;
