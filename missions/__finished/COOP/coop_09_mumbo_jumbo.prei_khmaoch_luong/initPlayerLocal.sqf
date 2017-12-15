cl_TeamAble = ["p_4","p_5","p_6","p_7","p_8"];
cl_TeamBaker = ["p_1","p_2","p_3"];



[ "InitializePlayer", [_unit] ] call BIS_fnc_dynamicGroups; // clientside initialization of the vanilla U-menu feature for group management 
enableSentences false;



cl_isRadioman = (vehicleVarName player) in ["p_1", "p_2", "p_3", "p_5"];

// if using TFR and wearing a radio backpack... swap it out!
if ( isClass (configFile >> "CfgPatches" >> "task_force_radio") ) then {
	if ( cl_isRadioman ) then {
		removeBackpack player;
		player addBackpack "tf_anprc155_coyote";
	};
};



// fixing the loadouts
player unlinkItem "ItemRadio";
//player unlinkItem (hmd player);



//*** The following functions are defined in the server-side mod's PreInit function, so we can assume they are defined here.
if (!isNil "SXF_Init_fnc_initSpecialHotkeys") then {
	// Add the F-key bindings that I like to use for my missions 
	call SXF_Init_fnc_initSpecialHotkeys;
};
if (!isNil "SXF_Utility_fnc_disableArsenalSavingLoading") then {
	// Disable the Saving and Loading buttons on the Arsenal so that people can't bypass the whitelisting
	call SXF_Utility_fnc_disableArsenalSavingLoading;
};


waitUntil { time > 0 };



player action ['SwitchWeapon', player, player, 99];



if ((vehicleVarName player) in cl_TeamBaker) then {
	//*** set a high view distance for this mission
	setViewDistance 8000;
	setObjectViewDistance 8000;
};



if ((vehicleVarName player) in cl_TeamAble) then {
	_guy = player;
	_paraPos = position _guy;
	if (! (vehicle _guy isEqualTo _guy) ) then { 
		_guy action ["GetOut", vehicle _guy]; 
	} else {
		_paraPos set [2, 155]; //combat jump altitude
		[_guy, _paraPos] remoteExec ["setPosATL", _guy];
		_guy setPosATL _paraPos;
	};
	sleep 6;
	//(parseText "You will be placed into a NON-steerable parachute for safety reasons in six seconds.<br/><br/>Enjoy the ride!") remoteExec ["hint", _guy];
	_paraPos = getPosASL _guy;
	_parachute =  createVehicle ["NonSteerable_Parachute_F", _paraPos, [], 0, "CAN_COLLIDE"];
	_parachute setDir (direction _guy);
	_parachute setPosASL _paraPos;
	_guy moveInDriver _parachute;
	//[_guy, _parachute] remoteExec ["moveInDriver", _guy];
};



//*** intro hint briefing message
hint parseText (
	format["<br/><t size='1.5' color='#E28014' align='center'>%1</t>", briefingName] +
	"<br/>by sixtyfour<br/>" +
	"<br/><br/>" +
	"<br/>Mission Settings:" +
	format ["<br/><t align='left'>Toggle 'Status Loop' Key:</t><t align='right'>%1 or %2</t>", 
		keyImage 0x3b, 
		keyImage (actionKeys "User1" select 0)
	] +
	"<br/><t align='left'>Medical Preset:</t><t align='right'>Vanilla Revive</t>" +
	"<br/><t align='left'>Bleed Out Duration:</t><t align='right'>5 minutes</t>" +
	"<br/><t align='left'>Revive Duration:</t><t align='right'>20 seconds</t>" +
	"<br/><t align='left'>Who Can Revive?:</t><t align='right'>Anyone (Medics 2.5x)</t>" +
	"<br/><t align='left'>First-Aid Kit required?:</t><t align='right'>Yes</t>" +
	"<br/><t align='left'>Medkit required?</t><t align='right'>No</t>" +
	"<br/><t align='left'>On Death:</t><t align='right'>Switch to Spectator</t>" +
	"<br/><t align='left'>AI Difficulty level:</t><t align='right'>4 of 7</t>" + 
	"<br/><br/><br/>"
);