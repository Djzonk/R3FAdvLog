/**
 * Modified by Sean Crowe, original script by Team ~R3F~
 * please see orginal work @ https://forums.bistudio.com/topic/170033-r3f-logistics/
 *
 * To get a full list of changes please contant me on the biforums under the username S.Crowe
 *
 * Copyright (C) 2014 Team ~R3F~
 *
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
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

if (R3F_LOG_mutex_local_lock) then {
    hintC STR_R3F_LOG_mutex_action_en_cours;
} else {
    R3F_LOG_mutex_local_lock = true;

    EGVAR(cargo,selectedObject) = objNull;

    private ["_pos_rel_object_initial", "_pos_rel_object", "_dernier_pos_rel_object", "_avant_dernier_pos_rel_object"];
    private ["_elev_cam_initial", "_elev_cam", "_offset_hauteur_cam", "_offset_bounding_center", "_offset_hauteur_terrain"];

    private _object = _this param [0, objNull];
    private _unload = _this param [3, false];
    private _player = player;
    private _playerDirection = getDir _player;

    if (isNull _object) exitWith {};

    if (isNull (_object getVariable [QGVAR(transportedBy), objNull]) && (isNull (_object getVariable [QGVAR(movedBy), objNull]) || (!alive (_object getVariable [QGVAR(movedBy), objNull])) || (!isPlayer (_object getVariable [QGVAR(movedBy), objNull])))) then {
        /*TODO remove if statement and use towing component to disable moving*/
        if (isNull (_object getVariable ["R3F_LOG_remorque", objNull])) then {
            _object setVariable [QGVAR(movedBy), _player, true];

            _player forceWalk true;

            GVAR(movingObject) = _object;

            if (_unload) then {
                // Orienter l'objet en fonction de son profil En: Orienting the object based on its profile
                /*TODO: figure out this if statement and rework if needed*/
                if (((boundingBoxReal _object select 1 select 1) - (boundingBoxReal _object select 0 select 1)) != 0 && // Div par 0
                    {
                        ((boundingBoxReal _object select 1 select 0) - (boundingBoxReal _object select 0 select 0)) > 3.2 &&
                        ((boundingBoxReal _object select 1 select 0) - (boundingBoxReal _object select 0 select 0)) /
                        ((boundingBoxReal _object select 1 select 1) - (boundingBoxReal _object select 0 select 1)) > 1.25
                    }
                ) then {
                    R3F_LOG_deplace_dir_rel_object = 90; /*TODO dose not need to be global*/
                } else {
                    R3F_LOG_deplace_dir_rel_object = 0;
                };

                // Calcul de la position relative, de sorte ? ?loigner l'objet suffisamment pour garder un bon champ de vision
                // En: Calculate the relative position so the object is far enough away to provide field of vision
                _pos_rel_object_initial = [
                    (boundingCenter _object select 0) * cos R3F_LOG_deplace_dir_rel_object - (boundingCenter _object select 1) * sin R3F_LOG_deplace_dir_rel_object,
                    ((-(boundingBoxReal _object select 0 select 0) * sin R3F_LOG_deplace_dir_rel_object) max (-(boundingBoxReal _object select 1 select 0) * sin R3F_LOG_deplace_dir_rel_object)) +
                    ((-(boundingBoxReal _object select 0 select 1) * cos R3F_LOG_deplace_dir_rel_object) max (-(boundingBoxReal _object select 1 select 1) * cos R3F_LOG_deplace_dir_rel_object)) +
                    2 + 0.3 * (((boundingBoxReal _object select 1 select 1) - (boundingBoxReal _object select 0 select 1)) * abs sin R3F_LOG_deplace_dir_rel_object +
                    ((boundingBoxReal _object select 1 select 0) - (boundingBoxReal _object select 0 select 0)) * abs cos R3F_LOG_deplace_dir_rel_object),
                    -(boundingBoxReal _object select 0 select 2)
                ];

                _elev_cam_initial = acos ((ATLtoASL positionCameraToWorld [0, 0, 1] select 2) - (ATLtoASL positionCameraToWorld [0, 0, 0] select 2));

                _pos_rel_object_initial set [2, 0.1 + (_player selectionPosition "head" select 2) + (_pos_rel_object_initial select 1) * tan (89 min (-89 max (90-_elev_cam_initial)))];
            } else {

                R3F_LOG_deplace_dir_rel_object = (getDir _object) - _playerDirection;

                _pos_rel_object_initial = _player worldToModel (_object modelToWorld [0,0,0]);

                // Calcul de la position relative de l'objet, bas?e sur la position initiale, et s?curis?e pour ne pas que l'objet rentre dans le joueur lors de la rotation
                // L'ajout de ce calcul a ?galement rendu inutile le test avec la fonction R3F_LOG_FNCT_unite_marche_dessus lors de la prise de l'objet
                _pos_rel_object_initial = [
                    _pos_rel_object_initial select 0,
                    (_pos_rel_object_initial select 1) max (((-(boundingBoxReal _object select 0 select 0) * sin R3F_LOG_deplace_dir_rel_object) max
                    (-(boundingBoxReal _object select 1 select 0) * sin R3F_LOG_deplace_dir_rel_object)) + ((-(boundingBoxReal _object select 0 select 1) * cos R3F_LOG_deplace_dir_rel_object) max
                    (-(boundingBoxReal _object select 1 select 1) * cos R3F_LOG_deplace_dir_rel_object)) + 1.2),
                    _pos_rel_object_initial select 2
                ];

                _elev_cam_initial = acos ((ATLtoASL positionCameraToWorld [0, 0, 1] select 2) - (ATLtoASL positionCameraToWorld [0, 0, 0] select 2));
            };
            R3F_LOG_deplace_distance_rel_object = _pos_rel_object_initial select 1;

            // D?termination du mode d'alignement initial en fonction du type d'objet, de ses dimensions, ...
            // En: Determining the initial alignment mode depending on the type of object, its dimensions, ...
            R3F_LOG_deplace_mode_alignement = switch (true) do {
                case !(_object isKindOf "Static"): {"sol"};
                // Objet statique allong? En: elongated static object?
                case (
                        ((boundingBoxReal _object select 1 select 1) - (boundingBoxReal _object select 0 select 1)) != 0 && // Div par 0
                        {
                            ((boundingBoxReal _object select 1 select 0) - (boundingBoxReal _object select 0 select 0)) /
                            ((boundingBoxReal _object select 1 select 1) - (boundingBoxReal _object select 0 select 1)) > 1.75
                        }
                    ): {"pente"};
                // Objet statique carr? ou peu allong?
                default {"horizon"};
            };


            // We request? That the object is local to the player for R?reduce the latencies (setDir, attachTo periodic)
            if (!local _object) then {
                private ["_time_demande_setOwner"];
                _time_demande_setOwner = time;

                [_object, clientOwner] remoteExec ["AdvLog_fnc_setOwner", 2];

                waitUntil {local _object || time > _time_demande_setOwner + 1.5};
            };

            /*// On pr?vient tout le monde qu'un nouveau objet va ?tre d?place pour ingorer les ?ventuelles blessures
            R3F_LOG_PV_nouvel_object_en_deplacement = _object;
            publicVariable "R3F_LOG_PV_nouvel_object_en_deplacement";
            ["R3F_LOG_PV_nouvel_object_en_deplacement", R3F_LOG_PV_nouvel_object_en_deplacement] call R3F_LOG_FNCT_PVEH_nouvel_object_en_deplacement;*/

            _object allowDamage false;

            // M?morisation de l'arme courante et de son mode de tir
            private _currentWeapon = currentWeapon _player;
            private _currentMuzzle = currentMuzzle _player;
            private _currentMuzzleMode = currentWeaponMode _player;

            // Sous l'eau on n'a pas le choix de l'arme
            if (!surfaceIsWater getPos _player) then {
                /*// Prise du PA si le joueur en a un
                if (handgunWeapon _player != "") then
                {
                    _restoreWeapon = false;
                    for [{_idx_muzzle = 0}, {currentWeapon _player != handgunWeapon _player}, {_idx_muzzle = _idx_muzzle+1}] do
                    {
                        _player action ["SWITCHWEAPON", _player, _player, _idx_muzzle];
                    };
                }
                // Sinon pas d'arme dans les mains
                else
                {
                    _restoreWeapon = true;
                    _player action ["SWITCHWEAPON", _player, _player, 99999];
                };*/

                private _restoreWeapon = true;
                _player action ["SWITCHWEAPON", _player, _player, 99999];
            } else {_restoreWeapon = false;};

            sleep 0.5;

            // V?rification qu'on ai bien obtenu la main (conflit d'acc?s simultan?s)
            if (_object getVariable QGVAR(movedBy) == _player && isNull (_object getVariable [QGVAR(transportedBy), objNull])) then {
                R3F_LOG_deplace_force_setVector = false; // Mettre ? true pour forcer la r?-otientation de l'objet, en for?ant les filtres anti-flood
                R3F_LOG_deplace_force_attachTo = false; // Mettre ? true pour forcer le repositionnement de l'objet, en for?ant les filtres anti-flood

                // Ajout des actions de gestion de l'orientation En: Add the orientation controls
                private _actionRelease = _player addAction [("<t color=""#ee0000"">" + format [STR_R3F_LOG_action_release_object, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")] + "</t>"), {_this call AdvLog_fnc_releaseObj;}, nil, 10, true, true];
                private _actionAlignSlope = _player addAction [("<t color=""#00eeff"">" + STR_R3F_LOG_action_align_slope + "</t>"), {R3F_LOG_deplace_mode_alignement = "pente"; R3F_LOG_deplace_force_setVector = true;}, nil, 6, false, true, "", "R3F_LOG_deplace_mode_alignement != ""pente"""];
                private _actionAlignGround = _player addAction [("<t color=""#00eeff"">" + STR_R3F_LOG_action_aligner_sol + "</t>"), {R3F_LOG_deplace_mode_alignement = "sol"; R3F_LOG_deplace_force_setVector = true;}, nil, 6, false, true, "", "R3F_LOG_deplace_mode_alignement != ""sol"""];
                private _actionAlignHorizon = _player addAction [("<t color=""#00eeff"">" + STR_R3F_LOG_action_aligner_horizon + "</t>"), {R3F_LOG_deplace_mode_alignement = "horizon"; R3F_LOG_deplace_force_setVector = true;}, nil, 6, false, true, "", "R3F_LOG_deplace_mode_alignement != ""horizon"""];
                private _actionTurn = _player addAction [("<t color=""#00eeff"">" + STR_R3F_LOG_action_tourner + "</t>"), {R3F_LOG_deplace_dir_rel_object = R3F_LOG_deplace_dir_rel_object + 12; R3F_LOG_deplace_force_setVector = true;}, nil, 6, false, false];
                private _actionDistance = _player addAction [("<t color=""#00eeff"">" + STR_R3F_LOG_action_rapprocher + "</t>"), {R3F_LOG_deplace_distance_rel_object = R3F_LOG_deplace_distance_rel_object - 0.4; R3F_LOG_deplace_force_attachTo = true;}, nil, 6, false, false];

                if (_object getVariable [QEGVAR(quartermaster,fromQuartermaster), false]) then {
                    private _action_cancel = _player addAction [format ["<t color=""#bd1526"">Return %1</t>", getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")], {GVAR(movingObject) setVariable["R3F_DeleteMe", true]; GVAR(movingObject) = objNull;}, nil, 6, false, false];
                };

                // Rel?cher l'objet d?s que le joueur tire. Le detach sert ? rendre l'objet solide pour ne pas tirer au travers.
                private _idEventhandlerFired = _player addEventHandler ["Fired", {if (!surfaceIsWater getPos player) then {detach GVAR(movingObject); GVAR(movingObject) = objNull;};}];

                // Gestion des ?v?nements KeyDown et KeyUp pour faire tourner l'objet avec les touches X/C En: Management? KeyDown and KeyUp events to rotate the object with the X / C
                R3F_LOG_player_deplace_key_rotation = "";
                R3F_LOG_player_deplace_key_translation = "";
                private _timeSinceLastRotation = 0;
                private _timeSinceLastTranslation = 0;
                private _idEventhandlerKeyDown = (findDisplay 46) displayAddEventHandler ["KeyDown",
                {
                    switch (_this select 1) do {
                        case 45: {R3F_LOG_player_deplace_key_rotation = "X"; true};
                        case 46: {R3F_LOG_player_deplace_key_rotation = "C"; true};
                        case 33: {R3F_LOG_player_deplace_key_translation = "F"; true};
                        case 19: {R3F_LOG_player_deplace_key_translation = "R"; true};
                        default {false};
                    }
                }];
                private _idEventhandlerKeyUp = (findDisplay 46) displayAddEventHandler ["KeyUp",
                {
                    switch (_this select 1) do {
                        case 45: {R3F_LOG_player_deplace_key_rotation = ""; true};
                        case 46: {R3F_LOG_player_deplace_key_rotation = ""; true};
                        case 33: {R3F_LOG_player_deplace_key_translation = ""; true};
                        case 19: {R3F_LOG_player_deplace_key_translation = ""; true};
                        default {false};
                    }
                }];

                // Initialisation de l'historique anti-flood En: anti-flood history initialization
                private _offsetHeight = _pos_rel_object_initial select 2;
                private _lastOffsetHeight = _offsetHeight + 100;
                private _secondLastOffsetHeight = _lastOffsetHeight + 100;
                _dernier_pos_rel_object = _pos_rel_object_initial;
                _avant_dernier_pos_rel_object = _dernier_pos_rel_object;
                private _vec_dir_rel = [sin R3F_LOG_deplace_dir_rel_object, cos R3F_LOG_deplace_dir_rel_object, 0];
                private _vectorDirectionUp = [_vec_dir_rel, [0, 0, 1]];
                private _lastVectorDirectionUp = [[0,0,0] vectorDiff (_vectorDirectionUp select 0), _vectorDirectionUp select 1];
                private _secondLastVectorDirectionUp = [_lastVectorDirectionUp select 0, [0,0,0] vectorDiff (_lastVectorDirectionUp select 1)];

                //Inital Object Atachto
                _object attachTo [_player, _pos_rel_object_initial];

                // Si ?chec transfert local, mode d?grad? : on conserve la direction de l'objet par rapport au joueur
                // En: If local transfer failure, degraded mode: it keeps the direction of the object relative to the player
                if (!local _object) then {
                    [_object,R3F_LOG_deplace_dir_rel_object] remoteExec ["AdvLog_fnc_setDir"];
                };

                R3F_LOG_mutex_local_lock = false;

                /*TODO: Convert to CBA PFH*/
                // events management loop and positioning during movement
                while {!isNull GVAR(movingObject) && _object getVariable QGVAR(movedBy) == _player && alive _player} do {
                    // Gestion de l'orientation de l'objet en fonction du terrain En: Management of the orientation of the object based on the terrain
                    if (local _object && !(_player getVariable[QGVAR(buildingObject), false])) then {
                        // Depending on the key pressed (X / C), the object is rotated
                        if (R3F_LOG_player_deplace_key_rotation == "X" || R3F_LOG_player_deplace_key_rotation == "C") then {
                            // Un cycle sur deux maxi (flood) on modifie de l'angle
                            /*TODO: Convert to ace scroll wheel*/
                            if (time - _timeSinceLastRotation > 0.045) then {
                                if (R3F_LOG_player_deplace_key_rotation == "X") then {R3F_LOG_deplace_dir_rel_object = R3F_LOG_deplace_dir_rel_object + 4;};
                                if (R3F_LOG_player_deplace_key_rotation == "C") then {R3F_LOG_deplace_dir_rel_object = R3F_LOG_deplace_dir_rel_object - 4;};

                                R3F_LOG_deplace_force_setVector = true;
                                _timeSinceLastRotation = time;
                            };
                        } else {_timeSinceLastRotation = 0;};

                        _vec_dir_rel = [sin R3F_LOG_deplace_dir_rel_object, cos R3F_LOG_deplace_dir_rel_object, 0];

                        // Conversion de la normale du sol dans le rep?re du joueur car l'objet est attachTo
                        private _surfaceNormal = surfaceNormal getPos _object;
                        _surfaceNormal = (player worldToModel ASLtoATL (_surfaceNormal vectorAdd getPosASL player)) vectorDiff (player worldToModel ASLtoATL (getPosASL player));

                        // Redefine the orientation depending on the terrain and the alignment mode
                        _vectorDirectionUp = switch (R3F_LOG_deplace_mode_alignement) do
                        {
                            case "sol": {[[-cos R3F_LOG_deplace_dir_rel_object, sin R3F_LOG_deplace_dir_rel_object, 0] vectorCrossProduct _surfaceNormal, _surfaceNormal]};
                            case "pente": {[_vec_dir_rel, _surfaceNormal]};
                            default {[_vec_dir_rel, [0, 0, 1]]};
                        };

                        // It re-orients the subject when necessary (no flood)
                        if (R3F_LOG_deplace_force_setVector ||
                            (
                                // Vector dir sufficiently different from the last
                                (_vectorDirectionUp select 0) vectorCos (_lastVectorDirectionUp select 0) < 0.999 &&
                                // and different from the penultimate (no endless oscillations)
                                vectorMagnitude ((_vectorDirectionUp select 0) vectorDiff (_secondLastVectorDirectionUp select 0)) > 1E-9
                            ) ||
                            (
                                // Vector up sufficiently different from the last
                                (_vectorDirectionUp select 1) vectorCos (_lastVectorDirectionUp select 1) < 0.999 &&
                                // and different from the penultimate (no endless oscillations)
                                vectorMagnitude ((_vectorDirectionUp select 1) vectorDiff (_secondLastVectorDirectionUp select 1)) > 1E-9
                            )
                        ) then {
                            _object setVectorDirAndUp _vectorDirectionUp;

                            _secondLastVectorDirectionUp = _lastVectorDirectionUp;
                            _lastVectorDirectionUp = _vectorDirectionUp;

                            R3F_LOG_deplace_force_setVector = false;
                        };
                    };

                    sleep 0.015;

                    // Depending on the key pressed (F / R), is advanced or reverse the object
                    if (R3F_LOG_player_deplace_key_translation == "F" || R3F_LOG_player_deplace_key_translation == "R") then {
                        // Un cycle sur deux maxi (flood) on modifie de l'angle
                        if (time - _timeSinceLastTranslation > 0.045) then {
                            if (R3F_LOG_player_deplace_key_translation == "F") then {
                                R3F_LOG_deplace_distance_rel_object = R3F_LOG_deplace_distance_rel_object - 0.075;
                            } else {
                                R3F_LOG_deplace_distance_rel_object = R3F_LOG_deplace_distance_rel_object + 0.075;
                            };

                            // Borne min-max de la distance
                            R3F_LOG_deplace_distance_rel_object = R3F_LOG_deplace_distance_rel_object min (
                                    (
                                        vectorMagnitude [
                                            (-(boundingBoxReal _object select 0 select 0)) max (boundingBoxReal _object select 1 select 0),
                                            (-(boundingBoxReal _object select 0 select 1)) max (boundingBoxReal _object select 1 select 1),
                                            0
                                        ] + 2
                                    ) max (_pos_rel_object_initial select 1)
                            ) max (
                                (
                                    ((-(boundingBoxReal _object select 0 select 0) * sin R3F_LOG_deplace_dir_rel_object) max (-(boundingBoxReal _object select 1 select 0) * sin R3F_LOG_deplace_dir_rel_object)) +
                                    ((-(boundingBoxReal _object select 0 select 1) * cos R3F_LOG_deplace_dir_rel_object) max (-(boundingBoxReal _object select 1 select 1) * cos R3F_LOG_deplace_dir_rel_object)) +
                                    1.2
                                )
                            );

                            R3F_LOG_deplace_force_attachTo = true;
                            _timeSinceLastTranslation = time;
                        };
                    } else {_timeSinceLastTranslation = 0;};

                    // Calcul de la position relative de l'objet, bas?e sur la position initiale, et s?curis?e pour ne pas que l'objet rentre dans le joueur lors de la rotation
                    // En: Calculating the relative position of the object, based on the initial position and secure not only the object enters the player during rotation
                    // L'ajout de ce calcul a ?galement rendu inutile le test avec la fonction R3F_LOG_FNCT_unite_marche_dessus lors de la prise de l'objet
                    _pos_rel_object = [
                        _pos_rel_object_initial select 0,
                        R3F_LOG_deplace_distance_rel_object max
                        (
                            ((-(boundingBoxReal _object select 0 select 0) * sin R3F_LOG_deplace_dir_rel_object) max (-(boundingBoxReal _object select 1 select 0) * sin R3F_LOG_deplace_dir_rel_object)) +
                            ((-(boundingBoxReal _object select 0 select 1) * cos R3F_LOG_deplace_dir_rel_object) max (-(boundingBoxReal _object select 1 select 1) * cos R3F_LOG_deplace_dir_rel_object)) +
                            1.2
                        ),
                        _pos_rel_object_initial select 2
                    ];

                    _elev_cam = acos ((ATLtoASL positionCameraToWorld [0, 0, 1] select 2) - (ATLtoASL positionCameraToWorld [0, 0, 0] select 2));
                    _offset_hauteur_cam = (vectorMagnitude [_pos_rel_object select 0, _pos_rel_object select 1, 0]) * tan (89 min (-89 max (_elev_cam_initial - _elev_cam)));
                    _offset_bounding_center = ((_object modelToWorld boundingCenter _object) select 2) - ((_object modelToWorld [0,0,0]) select 2);

                    // Calculating the height of the object based on the camera elevation and terrain
                    if (_object isKindOf "Static") then {
                        // In horizontal mode, the offset field range is calculated so to keep at least one of the four bottom corners in contact with the ground
                        if (R3F_LOG_deplace_mode_alignement == "horizon") then {
                            private _objectTerrainHeightMinMax = [_object] call R3F_LOG_FNCT_3D_get_hauteur_terrain_min_max_object;
                            private _minTerrainHeightOffset = (_objectTerrainHeightMinMax select 0) - (getPosASL _player select 2) + _offset_bounding_center;
                            private _maxTerrainHeightOffset = (_objectTerrainHeightMinMax select 1) - (getPosASL _player select 2) + _offset_bounding_center;

                            // Allow submering the object into the terrain up to 40% of object height
                            _minTerrainHeightOffset = _minTerrainHeightOffset min (_maxTerrainHeightOffset - 0.4 * ((boundingBoxReal _object select 1 select 2) - (boundingBoxReal _object select 0 select 2)) / (_lastVectorDirectionUp select 1 select 2));
                        // In other alignment modes, it allows a small burial up? 40% of the height of the object
                        } else {
                            _maxTerrainHeightOffset = getTerrainHeightASL (getPos _object) - (getPosASL _player select 2) + _offset_bounding_center;
                            _minTerrainHeightOffset = _maxTerrainHeightOffset - 0.4 * ((boundingBoxReal _object select 1 select 2) - (boundingBoxReal _object select 0 select 2)) / (_lastVectorDirectionUp select 1 select 2);
                        };

                        if (R3F_LOG_CFG_no_gravity_objects_can_be_set_in_height_over_ground) then{
                            _offsetHeight = _minTerrainHeightOffset max ((-1.4 + _offset_bounding_center) max ((2.75 + _offset_bounding_center) min ((_pos_rel_object select 2) + _offset_hauteur_cam)));
                        } else {
                            _offsetHeight = _minTerrainHeightOffset max (_maxTerrainHeightOffset min ((_pos_rel_object select 2) + _offset_hauteur_cam)) + (getPosATL _player select 2);
                        };
                    } else {
                        _offset_hauteur_terrain = getTerrainHeightASL (getPos _object) - (getPosASL _player select 2) + _offset_bounding_center;
                        _offsetHeight = _offset_hauteur_terrain max ((-1.4 + _offset_bounding_center) max ((2.75 + _offset_bounding_center) min ((_pos_rel_object select 2) + _offset_hauteur_cam)));
                    };

                    // We position the object relative to the player when needed (no flood)
                    if (R3F_LOG_deplace_force_attachTo ||
                        (
                            // sufficiently different height positioning
                            abs (_offsetHeight - _lastOffsetHeight) > 0.025 &&
                            // and different from the penultimate (no endless oscillations)
                            abs (_offsetHeight - _secondLastOffsetHeight) > 1E-9
                        ) ||
                        (
                            // sufficiently different relative position
                            vectorMagnitude (_pos_rel_object vectorDiff _dernier_pos_rel_object) > 0.025 &&
                            // and different from the penultimate (no endless oscillations)
                            vectorMagnitude (_pos_rel_object vectorDiff _avant_dernier_pos_rel_object) > 1E-9
                        )
                    ) then {
                        _object attachTo [_player, [
                            _pos_rel_object select 0,
                            _pos_rel_object select 1,
                            _offsetHeight
                        ]];

                        _secondLastOffsetHeight = _lastOffsetHeight;
                        _lastOffsetHeight = _offsetHeight;

                        _avant_dernier_pos_rel_object = _dernier_pos_rel_object;
                        _dernier_pos_rel_object = _pos_rel_object;

                        R3F_LOG_deplace_force_attachTo = false;
                    };

                    // On interdit de monter dans un v?hicule tant que l'objet est port?
                    if (vehicle _player != _player) then {
                        systemChat STR_R3F_LOG_ne_pas_monter_dans_vehicule;
                        _player action ["GetOut", vehicle _player];
                        _player action ["Eject", vehicle _player];
                        sleep 1;
                    };

                    // Le joueur change d'arme, on stoppe le d?placement et on ne reprendra pas l'arme initiale
                    if (currentWeapon _player != "" && currentWeapon _player != handgunWeapon _player && !surfaceIsWater getPos _player) then {
                        GVAR(movingObject) = objNull;
                        _restoreWeapon = false;
                    };

                    sleep 0.015;
                };

                // If the object is released? (And therefore not loaded? In a vehicle condition)
                if (isNull (_object getVariable [QGVAR(transportedBy), objNull])) then {
                    //The object is no longer port?, there the refitting. The?ger setVelocity upwards is used? Defreezer objects that could float.
                    // TODO gestion collision, en particulier si le joueur meurt

                    [_object, [0, 0, 0.1]] remoteExec ["AdvLog_fnc_detach"];

                    //[_object, "detachSetVelocity", [0, 0, 0.1]] call R3F_LOG_FNCT_exec_command_MP;
                };

                _player removeEventHandler ["Fired", _idEventhandlerFired];
                (findDisplay 46) displayRemoveEventHandler ["KeyDown", _idEventhandlerKeyDown];
                (findDisplay 46) displayRemoveEventHandler ["KeyUp", _idEventhandlerKeyUp];

                _player removeAction _actionRelease;
                _player removeAction _actionAlignSlope;
                _player removeAction _actionAlignGround;
                _player removeAction _actionAlignHorizon;
                _player removeAction _actionTurn;
                _player removeAction _actionDistance;
                if (!isNil "_action_cancel") then {
                    _player removeAction _action_cancel;
                };

                if (_object getVariable["R3F_DeleteMe", false]) then {
                    deleteVehicle _object;
                } else {
                    _object setVariable [QGVAR(movedBy), objNull, true];
                    _object setVariable [QEGVAR(quartermaster,fromQuartermaster), false, true];
                };
            // Failed to obtain the object
            } else {
                _object setVariable [QGVAR(movedBy), objNull, true];
                R3F_LOG_mutex_local_lock = false;
            };

            _player forceWalk false;
            GVAR(movingObject) = objNull;

            // Recovery of the weapon and restoring its shooting mode, if necessary
            if (alive _player && !surfaceIsWater getPos _player && _restoreWeapon) then {
                for [{_idx_muzzle = 0},
                    {currentWeapon _player != _currentWeapon ||
                    currentMuzzle _player != _currentMuzzle ||
                    currentWeaponMode _player != _currentMuzzleMode},
                    {_idx_muzzle = _idx_muzzle+1}] do {
                    _player action ["SWITCHWEAPON", _player, _player, _idx_muzzle];
                };
            };

            sleep 5; // 5 seconds to wait for the fall/stabilization
            if (!isNull _object) then {
                if (isNull (_object getVariable [QGVAR(movedBy), objNull]) ||
                    {(!alive (_object getVariable QGVAR(movedBy))) || (!isPlayer (_object getVariable QGVAR(movedBy)))}
                    )
                then {
                    _object allowDamage true;
                };
            };
        } else {
            hintC format [STR_R3F_LOG_object_remorque_en_cours, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
            R3F_LOG_mutex_local_lock = false;
        };
    } else {
        hintC format [STR_R3F_LOG_object_in_course_transport, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
        R3F_LOG_mutex_local_lock = false;
    };
};
