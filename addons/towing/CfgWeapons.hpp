class CfgWeapons {
    class ACE_ItemCore;
    class InventoryItem_Base_F;

    class AdvLog_TowCable: ACE_ItemCore {
        displayName = QUOTE(Emergency Tow Cable);// TODO: change to stringtable
        descriptionShort = QUOTE(Used for towing vehicles incase of an emergency.);// TODO: change to stringtable
        model = "\A3\Structures_F_EPA\Items\Tools\MetalWire_F.p3d";
        picture = QPATHTOF(data\tow.paa);
        scope = 2;
        class ItemInfo: InventoryItem_Base_F {
            mass = 12;
        };
    };
};
