params ["_unit", "_didJIP"];



[ "InitializePlayer", [_unit] ] call BIS_fnc_dynamicGroups; //clientside initialization of the vanilla U-menu feature for group management 
enableSentences false;



cl_didJIP = _didJIP;
cl_isAirborne = (((toLower typeOf player) splitString "_") find "para") != -1;
cl_isRadioman = (((toLower typeOf player) splitString "_") find "radioman") != -1;



// if using TFR and wearing a radio backpack... swap it out!
if ( isClass (configFile >> "CfgPatches" >> "task_force_radio") ) then {
	if ( cl_isRadioman ) then {
		if (!cl_isAirborne) then {
			removeBackpack player;
			player addBackpack "tf_anprc155_coyote";
		} else {
			player addEventHandler ["GetOutMan", {
				params ["_unit", "_position", "_vehicle", "_turret"];
				if (_vehicle isKindOf "LIB_Parachute_base") then {
					player addBackpack "tf_anprc155_coyote";
					player removeAllEventHandlers "GetOutMan";
				};
			}];
		};
	};
};



// Add the F-key bindings that I like to use for my missions 
call SXF_Init_fnc_initSpecialHotkeys;

// Disable the Saving and Loading buttons on the Arsenal so that people can't bypass the whitelisting
call SXF_Utility_fnc_disableArsenalSavingLoading;



waitUntil { time > 0 };

// if an airborne unit and not JIP'ing, get into that airplane!
/*
if ( cl_isAirborne ) then {
	if (cl_didJIP) then {
		player setPosATL (getMarkerPos "dropzone");
	} else {
		player moveInCargo jet_1;
/*
		waitUntil { player inArea trg_AirborneJump };

		player action ["GetOut", vehicle player];

		if (vehicleVarName player isEqualTo "p_10") then {
			waitUntil {isTouchingGround player};
			player addBackpack "tf_anprc155_coyote";
		};

	};
};
*/