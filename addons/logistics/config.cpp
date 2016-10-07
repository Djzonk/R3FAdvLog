#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"r3fadvlog_main"};
        author = ECSTRING(main,Author);
        authors[] = {""};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

class CBA_Extended_EventHandlers_base;
#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
