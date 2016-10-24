/**
 * Formate un nombre entier avec des séparateurs de milliers
 * Formate an integer with thousands of separators
 *
 * @param 0 le nombre à formater En: The number to format
 * @return chaîne de caractère représentant le nombre formaté En: String representing the formatted number
 *
 * Copyright (C) 2014 Team ~R3F~
 *
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
/*

            TODO: SWITCH TO CBA_fnc_formatNumber

 */
#include "script_component.hpp"

private ["_number", "_hundreds", "_str_sign", "_str_number", "_str_hundreds"];

_number = _this select 0;

_str_sign = if (_number < 0) then {"-"} else {""};
_number = floor abs _number;

_str_number = "";
while {_number >= 1000} do {
    _hundreds = _number - (1000 * floor (0.001 * _number));
    _number = floor (0.001 * _number);

    if (_hundreds < 100) then {
        if (_hundreds < 10) then {
            _str_hundreds = "00" + str _hundreds;
        } else {
            _str_hundreds = "0" + str _hundreds;
        };
    } else {
        _str_hundreds = str _hundreds;
    };

    _str_number = "." + _str_hundreds + _str_number;
};

_str_sign + str _number + _str_number
