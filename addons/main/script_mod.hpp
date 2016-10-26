// COMPONENT should be defined in the script_component.hpp and included BEFORE this hpp

#define MAINPREFIX z
#define PREFIX r3fadvlog

#define MAJOR 1
#define MINOR 0
#define PATCHLVL 0
#define BUILD 0

#define VERSION MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_AR MAJOR,MINOR,PATCHLVL,BUILD

#define R3FADVLOG_TAG R3FADVLOG

// MINIMAL required version for the Mod. Components can specify others..
#define REQUIRED_VERSION 1.56
#define REQUIRED_CBA_VERSION {3,1,0}

// Mod Wide Debug
#define DEBUG_MODE_FULL
#define DISABLE_COMPILE_CACHE
// #define CBA_DEBUG_SYNCHRONOUS
// #define ENABLE_PERFORMANCE_COUNTERS
