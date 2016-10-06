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

params ["_object"];
_type = typeOf _object;
TRACE_2("params",_object,_type);


// do nothing if the class is already initialized
if (_type in GVAR(initializedItemClasses)) exitWith {};
GVAR(initializedItemClasses) pushBack _type;

//Load Action
    /*TODO: Rework
      add easy way for user to determin loadable objects
      use below line as condition
      if ((_object getVariable [QGVAR(canLoad), getNumber (configFile >> "CfgVehicles" >> _type >> "ace_cargo_canLoad")]) != 1) exitWith {};
    */
if (([_object] call AdvLog_fnc_canBeTransported) select 0) then {

    _myaction = ["R3F_load", format [STR_R3F_LOG_action_select_object_load, _name],"z\ace\addons\cargo\UI\Icon_load.paa",{_this call AdvLog_fnc_selected;},{!R3F_LOG_mutex_local_lock},{}] call ace_interact_menu_fnc_createAction;

    [_object, 0, ["ACE_MainActions"], _myaction] call ace_interact_menu_fnc_addActionToObject;

};


//Move Action
    /*TODO: Rework*/
if ([_object] call AdvLog_fnc_canMove) then {

    _myaction = ["R3F_move", format [STR_R3F_LOG_action_move_object, _name],"z\ace\addons\dragging\UI\icons\box_carry.paa",{_this spawn AdvLog_fnc_moveObj;},{!R3F_LOG_mutex_local_lock},{}] call ace_interact_menu_fnc_createAction;

    [_object, 0, ["ACE_MainActions"], _myaction] call ace_interact_menu_fnc_addActionToObject;

};

//Push action
    /*TODO: Rework*/
if (([_object] call AdvLog_fnc_canPush)) then {

    if (!(_object isKindOf "Ship_F")) then {
        _myaction = ["R3F_push", "Push","",{_this call ace_interaction_fnc_push},{(vectorMagnitude (velocity (_this select 0)) < 3)},{}] call ace_interact_menu_fnc_createAction;

        [_object, 0, ["ACE_MainActions"], _myaction] call ace_interact_menu_fnc_addActionToObject;
    };
};
