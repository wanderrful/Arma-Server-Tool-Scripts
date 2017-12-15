//Verify that the server is running my serverside "sxf_library" mod
_bUsingSXFLibrary = isClass (configFile >> "CfgPatches" >> "sxf_library");
if (!_bUsingSXFLibrary) exitWith {};



// set my preferred TFR settings
call SXF_Init_fnc_initTFRSettingsIfUsing;



waitUntil { time > 0 }; // Mission start



call SXF_Init_fnc_initLoopMessage;
[0, false] call SXF_Init_fnc_initMissionTimer;