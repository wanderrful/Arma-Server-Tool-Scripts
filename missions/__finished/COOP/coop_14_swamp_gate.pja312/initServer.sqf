[ "Initialize" ] call BIS_fnc_dynamicGroups; //serverside initialization of the vanilla U-menu feature for group management
enableSentences false;



//Verify that the server is running my serverside "sxf_library" mod
_bUsingSXFLibrary = isClass (configFile >> "CfgPatches" >> "sxf_library");
if (!_bUsingSXFLibrary) exitWith {};



// set my preferred TFR settings
call SXF_Init_fnc_initTFRSettingsIfUsing;



waitUntil { time > 0 }; // Mission start



call SXF_Init_fnc_initLoopMessage;
[0, false] call SXF_Init_fnc_initMissionTimer;



[ "ItemAdd", ["FailLoop1", {
	if (blufor countSide allUnits <= 0) then {
		"TeamWipedOut" call SXF_ScenarioFlow_fnc_handleMissionFailed;
		[ "ItemRemove", ["FailLoop1"] ] call BIS_fnc_loop;
	};
}, 1, "seconds" ]] call BIS_fnc_loop;



