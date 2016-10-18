#include "dlgDefines.hpp"

#define 0.027 0.027

class GVAR(menu) {
    idd = 65431;
    name = "R3F_LOG_dlg_contenu_vehicule";
    onLoad = QUOTE([_this select 0] call FUNC(onMenuOpen));
    onUnload = QUOTE(uiNamespace setVariable [ARR_2(QUOTE(QGVAR(menuDisplay)),nil)];);
    movingEnable = false;

    controlsBackground[] = {
        class TitleBackground : R3FAdvLog_Cargo_Text {
            x = 0.26;
            y = 0.145 - 0.027-0.005;
            w = 0.45;
            h = 0.07;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])","(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"};
        };
        class BlackBackground : R3FAdvLog_Cargo_Text {
            x = 0.26;
            y = 0.220 - 0.027-0.005;
            w = 0.45;
            h = 0.027 + 0.010 + 0.54 - 0.005;
            colorBackground[] = {0,0,0,0.5};
        };
    };
    objects[] = {};
    controls[] = {
        class Title : R3FAdvLog_Cargo_Text {
            idc = 65440;
            x = 0.26;
            y = 0.145 - 0.027-0.005;
            w = 0.45;
            h = 0.04;
            sizeEx = 0.05;
            text = text = CSTRING(dlg_Title);;
        };
        class VehicleCapacity : R3FAdvLog_Cargo_Text {
            idc = 65432;
            x = 0.255;
            y = 0.185 - 0.027-0.005;
            w = 0.4;
            h = 0.03;
            sizeEx = 0.03;
            text = CSTRING(dlg_Capacity);
        };
        class capacityGauge {
            idc = 65443;
            type = CT_PROGRESS;
            style = ST_LEFT;
            x = 0.26 + 0.0035;
            y = 0.220 - 0.027-0.005 + 0.0035;
            w = 0.45 - 0.007;
            h = 0.027;
            shadow = 2;
            colorBar[] = {0.9,0.9,0.9,0.9};
            colorExtBar[] = {1,1,1,1};
            colorFrame[] = {1,1,1,1};
            texture = "";
            textureExt = "";
        };
        class CargoList : R3FAdvLog_Cargo_List {
            idc = 65433;
            x = 0.26;
            y = 0.22 + 0.005;
            w = 0.45;
            h = 0.54 - 0.005;
            onLBDblClick = "[] spawn AdvLog_fnc_unloading;";
            onLBSelChanged = QUOTE(uiNamespace setVariable [ARR_2(QGVAR(menuSelected), (_this select 0) lbData (_this select 1))];);
        };

        class Credits : R3FAdvLog_Cargo_Text {
            idc = 65441;
            x = 0.255;
            y = 0.813;
            w = 0.19;
            h = 0.02;
            colorText[] = {0.5,0.5,0.5,0.75};
            font = "PuristaLight";
            sizeEx = 0.02;
            text = "[R3F] Logistics";
        };
        class UnloadButton : R3FAdvLog_Cargo_Button {
            idc = 65434;
            x = 0.365;
            y = 0.765;
            sizeEx = 0.02;
            text = CSTRING(dlg_Unload);
            action = "[] spawn AdvLog_fnc_unloading;";
        };
        class CancelButton : R3FAdvLog_Cargo_Button {
            idc = 65442;
            x = 0.54;
            y = 0.765;
            text = CSTRING(dlg_Cancel);
            action = "closeDialog 0;";
        };
    };
