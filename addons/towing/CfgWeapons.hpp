class CfgWeapons {
    class ACE_ItemCore;
    class InventoryItem_Base_F;

    class AdvLog_TowCable: ACE_ItemCore {
        displayName = "Emergency Tow Cable";
        descriptionShort = "Used for towing vehicles incase of an emergency.";
        model = "\A3\Structures_F_EPA\Items\Tools\MetalWire_F.p3d";
        picture = "\r3fAdvLog\data\tow.paa";
        scope = 2;
        class ItemInfo: InventoryItem_Base_F {
        	mass = 12;
        };
    };
};
