//CLIENTSIDE

//Defines and implements the special hotkeys that I like to use for all of my missions

if (!hasInterface) exitWith {};



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

//*** F4 key:  Re-level the jet in case it is stuck in the ground somehow
sxf_fnc_handleKey_F4 = {
	if ( isTouchingGround (vehicle player) && {(vehicle player) isKindOf "Plane"} ) then {
		_pos = getPosASL (vehicle player);
		_pos set [2, 1 + (_pos select 2)];
		vehicle player setPosASL _pos;
	};
};

//*** F5 key:  Toggle use of earplugs
sxf_fnc_handleKey_F5 = {
	_temp = player getVariable ["sxf_bEarplugsActivated", false];
	player setVariable ["sxf_bEarplugsActivated", !_temp, false];
	1 fadeSound ([0.2, 1] select !_temp);
	systemChat (["Earplugs OUT", "Earplugs IN"] select !_temp);
};



//*** Assign special key bindings for this mission
waituntil {!(IsNull (findDisplay 46))};
//(findDisplay 46) displayRemoveAllEventHandlers "KeyDown";
(findDisplay 46) displayAddEventHandler [
	"KeyDown", 
	{
			if ( (_this select 1) in ( (actionKeys 'User1') + [0x3b] ) ) then {call sxf_fnc_handleKey_F1;};
			if ( (_this select 1) in ( (actionKeys 'User2') + [0x3c, 0x0b] ) ) then {call sxf_fnc_handleKey_F2;};
			if ( (_this select 1) in ( (actionKeys 'User3') + [0x3d] ) ) then {call sxf_fnc_handleKey_F3;};
			if ( (_this select 1) in ( (actionKeys 'User4') + [0x3e] ) ) then {call sxf_fnc_handleKey_F4;};
			if ( (_this select 1) in ( (actionKeys 'User5') + [0x3f] ) ) then {call sxf_fnc_handleKey_F5;};
	}
];



//display the helpful key bindings reminder early on into the mission
[] spawn {	
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
		format["<br/><t align='left'>Press <t color='%1'>%2</t> or <t color='%1'>%3</t> to toggle earplugs!</t>",
			"#6db9e2",
			keyName 0x3f, 
			[keyName (actionKeys "User5" select 0), "--UNBOUND--"] select (count actionKeys "User5" <= 0)
		] +
		"<br/><br/><br/>"
	);
};