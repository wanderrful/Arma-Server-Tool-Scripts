[ "Initialize" ] call BIS_fnc_dynamicGroups; //serverside initialization of the vanilla U-menu feature for group management
enableSentences false;



//Verify that the server is running my serverside "sxf_library" mod
_bUsingSXFLibrary = isClass (configFile >> "CfgPatches" >> "sxf_library");



if (_bUsingSXFLibrary) then {
	// set my preferred TFR settings
	call SXF_Init_fnc_initTFRSettingsIfUsing;
	// initialize the server's half of the players' F1 looping status message
	call SXF_Init_fnc_initLoopMessage;
	[0, false] call SXF_Init_fnc_initMissionTimer;
};



waitUntil { time > 0 }; // Mission start



[ "ItemAdd", ["FailLoop1", {
	if (blufor countSide allUnits <= 0) then {
		"TeamWipedOut" call SXF_ScenarioFlow_fnc_handleMissionFailed;
		[ "ItemRemove", ["FailLoop1"] ] call BIS_fnc_loop;
	};
}, 2, "seconds" ]] call BIS_fnc_loop;

[ "ItemAdd", ["WinLoop2", {
	if (opfor countSide allUnits <= 0) then {
		true call SXF_ScenarioFlow_fnc_handleMissionCompleted;
		[ "ItemRemove", ["WinLoop2"] ] call BIS_fnc_loop;
	};
}, 2, "seconds" ]] call BIS_fnc_loop;



[ "ItemAdd", ["CuratorLoop", {
	if (count allCurators > 0) then {
		{ 
			_temp = _x; 
			{ 
				if ( isPlayer _x || { !(_x in curatorEditableObjects _temp) } ) then {
					_temp addCuratorEditableObjects [[_x], true]; 
				};
			} forEach allUnits; 
		} forEach allCurators;
	} else {
		[ "ItemRemove", ["CuratorLoop"] ] call BIS_fnc_loop;
	};
}, 5, "seconds" ]] call BIS_fnc_loop;