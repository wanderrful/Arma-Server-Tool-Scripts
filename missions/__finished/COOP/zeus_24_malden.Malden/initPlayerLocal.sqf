params ["_unit", "_didJIP"];

//*** Define the initial settings
if (count call BIS_fnc_listPlayers <= 1) then {
	player allowDamage false;
	OnMapSingleClick { player setPos _pos; };
};

[ "InitializePlayer", [_unit] ] call BIS_fnc_dynamicGroups; //clientside initialization of the vanilla U-menu feature for group management 
enableSentences false;



//*** F1 key:  Toggle the mission status hint message loop
sxf_fnc_handleKey_F1 = {
	_temp = player getVariable ['sxf_bLoopEnabled', false];
	if (_temp) then {hintSilent '';};
	playSound ( ['AddItemFailed', 'AddItemOK'] select !_temp );
	player setVariable ['sxf_bLoopEnabled', !_temp, true];
};
//*** F2 key:  Holster the current weapon
sxf_fnc_handleKey_F2 = {
	player action ['SwitchWeapon', player, player, 99];
};
//*** F3 key:  Push the jet backward in case it gets stuck
sxf_fnc_handleKey_F3 = {
	_vehicle = vehicle player; 
	_vel = velocity _vehicle;
	_dir = direction _vehicle; 
	if ( _vehicle isKindOf "Plane") then {
		if (speed _vehicle <= 5) then {
			_vehicle setVelocity [ 
			 (_vel select 0) + (sin _dir * -10),  
			 (_vel select 1) + (cos _dir * -10),  
			 (_vel select 2) 
			];
		} else {
			playSound "AddItemFailed";
			titleText ["ERROR - Your plane must be still in order to reverse!", "PLAIN"];
		};
	} else {
		playSound "AddItemFailed";
		//titleText ["ERROR - You are not in a jet!", "PLAIN"];
	};
};
sxf_fnc_handleKey_F4 = {
	if ( isTouchingGround (vehicle player) && {(vehicle player) isKindOf "Plane"} ) then {
		_pos = getPosASL (vehicle player);
		_pos set [2, 1 + (_pos select 2)];
		vehicle player setPosASL _pos;
	};
};



//*** Assign special key bindings for this mission
waituntil {!(IsNull (findDisplay 46))};
(findDisplay 46) displayRemoveAllEventHandlers "KeyDown";
(findDisplay 46) displayAddEventHandler [
	"KeyDown", 
	{
			if ( (_this select 1) in ( (actionKeys 'User1') + [0x3b] ) ) then {call sxf_fnc_handleKey_F1;};
			if ( (_this select 1) in ( (actionKeys 'User2') + [0x3c] ) ) then {call sxf_fnc_handleKey_F2;};
			if ( (_this select 1) in ( (actionKeys 'User3') + [0x3d] ) ) then {call sxf_fnc_handleKey_F3;};
			if ( (_this select 1) in ( (actionKeys 'User4') + [0x3e] ) ) then {call sxf_fnc_handleKey_F4;};
	}
];
[] spawn {	//display the helpful key bindings reminder early on into the mission
	sleep 45;
	hint parseText (
		"<br/><t size='1.5' color='#E28014' align='center'>Quick reminder!</t>" +
		"<br/><br/>" +
		format["<br/><t align='left'>Press <t color='%1'>%2</t> or <t color='%1'>%3</t> to toggle the mission status loop message.</t>",
			"#e285e0",
			keyName 0x3b, 
			[keyName (actionKeys "User1" select 0), "--UNBOUND--"] select (count actionKeys "User1" <= 0)
		] +
		"<br/><br/>" +
		format["<br/><t align='left'>Press <t color='%1'>%2</t> or <t color='%1'>%3</t> to holster your weapon so that you can run faster and save stamina.</t>",
			"#6db9e2",
			keyName 0x3c, 
			[keyName (actionKeys "User2" select 0), "--UNBOUND--"] select (count actionKeys "User2" <= 0)
		] +
		"<br/><br/>" +
		format["<br/><t align='left'>Press <t color='%1'>%2</t> or <t color='%1'>%3</t> to push your jet backward if you're stuck.</t>",
			"#e285e0",
			keyName 0x3d, 
			[keyName (actionKeys "User3" select 0), "--UNBOUND--"] select (count actionKeys "User3" <= 0)
		] +
		"<br/><br/>" +
		format["<br/><t align='left'>Press <t color='%1'>%2</t> or <t color='%1'>%3</t> if your jet gets stuck inside the carrier!</t>",
			"#6db9e2",
			keyName 0x3e, 
			[keyName (actionKeys "User4" select 0), "--UNBOUND--"] select (count actionKeys "User4" <= 0)
		] +
		"<br/><br/>" +
		"<br/><br/><br/>"
	);
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
	"<br/><t align='left'>Bleed Out Duration:</t><t align='right'>3 minutes</t>" +
	"<br/><t align='left'>Revive Duration:</t><t align='right'>20 seconds</t>" +
	"<br/><t align='left'>Who Can Revive?:</t><t align='right'>Anyone (Medics, 2x revive speed)</t>" +
	"<br/><t align='left'>First-Aid Kit required?:</t><t align='right'>No</t>" +
	"<br/><t align='left'>Medkit required?</t><t align='right'>Yes</t>" +
	"<br/><t align='left'>On Death:</t><t align='right'>Switch to Spectator</t>" +
	"<br/><t align='left'>AI Difficulty level:</t><t align='right'>4 of 7</t>" + 
	"<br/><br/><br/>"
);



//*** set a high view distance when in an aircraft, low view distance when exiting an aircraft
player addEventHandler ["GetInMan", {
	params ["_unit", "_position", "_vehicle", "_turret"];
	if (_vehicle isKindOf "Air") then {
		setViewDistance 8000;
		setObjectViewDistance 8000;
	};
}];
player addEventHandler ["GetOutMan", {
	params ["_vehicle", "_position", "_unit", "_turret"];
	if (_vehicle isKindOf "Air") then {
		setViewDistance 1200;
		setObjectViewDistance 1200;
	};
}];



//*** Send the player to the carrier when they first load into the mission!
sxf_fnc_sendPlayerToCarrier = {
	_pos = getMarkerPos "carrier_respawn";
	_pos set [2, 23];
	_this setPosASL _pos;
};
player call sxf_fnc_sendPlayerToCarrier;



//*** Special Zeus stuff
waitUntil { !isNull (getAssignedCuratorLogic player) };
(getAssignedCuratorLogic player) addEventHandler ["CuratorObjectPlaced", {
	params ["_curator", "_object"];
	if (_object isKindOf "Man") then {
		_object setUnitLoadout [["arifle_AKS_F","","","",["30Rnd_545x39_Mag_F",30],[],""],[],["hgun_P07_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_I_C_Soldier_Camo_F",[["FirstAidKit",4]]],["V_PlateCarrierIA1_dgtl",[["30Rnd_545x39_Mag_F",8,30],["16Rnd_9x21_Mag",1,16],["MiniGrenade",1,1],["SmokeShell",3,1],["APERSBoundingMine_Range_Mag",1,1]]],[],"H_Shemag_olive","",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]];
	};
}];