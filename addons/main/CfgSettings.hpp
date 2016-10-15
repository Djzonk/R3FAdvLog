class CfgSettings {
   class CBA {
      class Versioning {
         class R3FADVLOG {
            class Dependencies {
               CBA[]={"cba_main", REQUIRED_CBA_VERSION, "true"};
            };

           // Optional: Removed addons Upgrade registry
           // Example: myMod_addon1 was removed and it's important the user doesn't still have it loaded
           //removed[] = {"myMod_addon1"};
         };
      };
   };
};
