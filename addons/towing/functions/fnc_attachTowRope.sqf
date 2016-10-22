/*
Modified by Sean Crowe
please see orginal work @ forums.bistudio.com/topic/188980-advanced-towing

To get a full list of changes please contant me on the biforums under the username S.Crowe

The MIT License (MIT)

Copyright (c) 2016 Seth Duda

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
/*
* Author: [Name of Author(s)]
* [Description]
*
* Arguments:
* 0: Vehicle geting towed <OBJECT>
*
* Return Value:
* Return Name <TYPE>
*
* Example:
* ["example"] call r3fadvlog_[module]_fnc_[functionName]
*
* Public: No
*/
#include "script_component.hpp"

params ["_target","_player"];
private _helper = _player getVariable [QGVAR(towRopeHelper), objNull];
private _towRopeOwner = _helper getVariable [QGVAR(towRopeOwner), objNull];

if(!local _towRopeOwner) then {
    [_towRopeOwner, clientOwner] remoteExec ["AdvLog_fnc_setOwner", 2];
};

if((_towRopeOwner getVariable [QGVAR(towRopeExtended), false]) == true) then {

    private _targetHitch = ([_target] call AdvLog_fnc_getHitchPoints) select 0;
    private _ownerHitch = ([_towRopeOwner] call AdvLog_fnc_getHitchPoints) select 1;

    private _ropeLength = ropeLength (_helper getVariable [QGVAR(towRope) objNull]);
    
    private _objDistance = ((_towRopeOwner modelToWorld _ownerHitch) distance (_target modelToWorld _targetHitch));

    if( _objDistance > _ropeLength ) then {
        "The tow ropes are too short. Move vehicle closer." remoteExecCall ["systemChat", _player];
    } else {

        detach _helper;
        _helper attachTo [_target, _targetHitch];

        _player setVariable [QGVAR(towRopeHelper), objNull];
        call ace_interaction_fnc_hideMouseHint;

        _helper setVariable ["SA_Cargo",_target,true];

        [_towRopeOwner,_ownerHitch,_target,_targetHitch] spawn AdvLog_fnc_simulateTowing;
    };
};