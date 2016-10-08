class Extended_PreStart_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preStart));
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
    };
};
class Extended_PostInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_postInit));
    };
};
class Extended_Init_EventHandlers {
    class ThingX {
        class ADDON {
            init = QUOTE(_this call DFUNC(initObject); _this call DFUNC(initVehicle));
        };
    };
    class LandVehicle {
        class ADDON {
            init = QUOTE(_this call DFUNC(initVehicle));
        };
	};
    class Air {
        class ADDON {
            init = QUOTE(_this call DFUNC(initVehicle));
        };
	};
    class Ship {
        class ADDON {
            init = QUOTE(_this call DFUNC(initVehicle));
        };
	};
    class StaticWeapon {
        class ADDON {
            init = QUOTE(_this call DFUNC(initObject));
        };
    };
};
