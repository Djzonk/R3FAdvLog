class CBA_Extended_EventHandlers;

class CfgVehicles {
    class Items_base_F;
    // TODO: replace with actual model
    class GVAR(pickUpHelper): Items_base_F {
        author = ECSTRING(main,Author);
        displayName = "R3FADVLOG towing pickup helper";
        model = "\a3\weapons_f\dummyweapon.p3d";
        scope = 1;

        class ACE_Actions {
            class ACE_MainActions {
                condition = "true";
                statement = "";
                showDisabled = 0;
                class GVAR(pickUp) {
                    displayName = CSTRING(TakeTowRope);
                    condition = QUOTE(true);// TODO change
                    statement = QUOTE([ARR_3(_player,objNull,_target)] call FUNC(takeTowRope));
                    exceptions[] = {"isNotInside"};
                };
            };
        };

        class EventHandlers {
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers {};
        };
    };
};