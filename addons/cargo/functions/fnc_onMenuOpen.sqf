/*
* Author: DjZonk, S.Crowe, R3f team
* controls the data displayed in the cargo menu
*
* Arguments:
* 0: Display <DISPLAY>
*
* Return Value:
* None
*
* Example:
* [display] call r3fadvlog_cargo_fnc_onMenuOpen
*
* Public: No
*/
#include "script_component.hpp"
disableSerialization;

params ["_display"];
uiNamespace setVariable [QGVAR(menuDisplay), _display];

[{
    disableSerialization;
    private _display = uiNamespace getVariable QGVAR(menuDisplay);
    if (isNil "_display") exitWith {
        [_this select 1] call CBA_fnc_removePerFrameHandler;
    };

    // Get the contents of the vehicle
    private _cargoList = GVAR(interactionVehicle) getVariable [QGVAR(vehicleCargolist), []];

    /** List of the names of the class of the objects contained in the vehicle without duplicate */
    private _objectTab = [];
    /** Quantities? Associated with? (By the index) to the names of class in _objectTab*/
    private _quantityTab = [];
    /** Cost of associated loading? (By the index) to the names of class in _objectTab */
    private _objectSizeTab = [];

    // preparing the content list and quantities?s associated with?es to objects
    /*for [{_i = 0}, {_i < count _cargo}, {_i = _i + 1}] do {

        if !((typeOf _object) in _objectTab) then {
            _objectTab pushBack (typeOf _object);
            _quantityTab pushBack 1;

            _objectSizeTab pushBack (([_object] call FUNC(canBeTransported)) param [1, 0]);

        } else {
            private ["_objectIndex"];
            _objectIndex = _objectTab find (typeOf _object);
            _quantityTab set [_objectIndex, ((_quantityTab select _objectIndex) + 1)];
        };
    };*/
    {
        private _object = _x
        if !((typeOf _object) in _objectTab) then {
            _objectTab pushBack (typeOf _object);
            _quantityTab pushBack 1;

            _objectSizeTab pushBack _object getVariable QGVAR(size);

        } else {
            private _objectIndex = _objectTab find (typeOf _object);
            _quantityTab set [_objectIndex, ((_quantityTab select _objectIndex) + 1)];
        };
    } count _cargoList;

    private _totalCargoSize = GVAR(interactionVehicle) getVariable QGVAR(totalCargoSize);
    private _maxCapacity = GVAR(interactionVehicle) getVariable QGVAR(maxCapacity);
    private _ctrlList = _display displayCtrl 65433;

    lbClear _ctrlList;
    //set capacity indicator
    (_display displayCtrl 65432) ctrlSetText (format [localize LSTRING(dlg_Capacity)+" pl.", _totalCargoSize, _maxCapacity]);
    //set capacity gauge
    if (_maxCapacity != 0) then {(_display displayCtrl 65443) progressSetPosition (_totalCargoSize / _maxCapacity);};
    //hides gauge is no cargo
    (_display displayCtrl 65443) ctrlShow (_totalCargoSize != 0);

    if (count _objectTab == 0) then {
        //disableds unload button if no cargo
        (_display displayCtrl 65434) ctrlEnable false;
    } else {

        {
            //adds each object type to the list
            _objectIndex = _objectTab find (typeOf _x);

            private _class = _objectTab select _objectIndex;
            private _quantity = _quantityTab select _objectIndex;
            private _size = _objectSizeTab select _objectIndex;
            private _icon = getText (configFile >> "CfgVehicles" >> _class >> "icon");

            // Default icon
            if (_icon == "") then {
                _icon = "\A3\ui_f\data\map\VehicleIcons\iconObject_ca.paa";
            };

            // If the path begins with A3 \ or a3 \, add a \ to the beginning
            private _iconTab = toArray toLower _icon;
            if (count _iconTab >= 3 && {
                    _iconTab select 0 == (toArray "a" select 0) &&
                    _iconTab select 1 == (toArray "3" select 0) &&
                    _iconTab select 2 == (toArray "\" select 0)})
            then{
                _icon = "\" + _icon;
            };

            // Si ic?ne par d?faut, on rajoute le chemin de base par d?faut
            _iconTab = toArray _icon;
            if (_iconTab select 0 != (toArray "\" select 0)) then {
                _icon = format ["\A3\ui_f\data\map\VehicleIcons\%1_ca.paa", _icon];
            };

            // if no file extension we add ".paa"
            _iconTab = toArray _icon;
            if (count _iconTab >= 4 && {_iconTab select (count _iconTab - 4) != (toArray "." select 0)}) then {
                _icon = _icon + ".paa";
            };

            private _index = _ctrlList lbAdd (getText (configFile >> "CfgVehicles" >> _class >> "displayName") + format [" (%1x %2pl.)", _quantity, _size]);
            _ctrlList lbSetPicture [_index, _icon];
            _ctrlList lbSetData [_index, _class];

            if (uiNamespace getVariable QGVAR(menuSelected) == _class) then {
                _ctrlList lbSetCurSel _index;
            };
        } count _objectTab

        (_display displayCtrl 65434) ctrlEnable true;
    };
}, 0, []] call CBA_fnc_addPerFrameHandler;
