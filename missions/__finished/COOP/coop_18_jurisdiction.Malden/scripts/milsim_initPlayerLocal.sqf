params ["_unit", "_didJIP"];

//*** Define the initial settings
if (count call BIS_fnc_listPlayers <= 1) then {
	player allowDamage false;
	OnMapSingleClick { player setPos _pos; };
};

[ "InitializePlayer", [_unit] ] call BIS_fnc_dynamicGroups; //clientside initialization of the vanilla U-menu feature for group management 
enableSentences false;



//*** Disable Saving and Loading of Arsenal loadouts! (still worth having here even if it's not an Arsenal mission)
[ missionNamespace, "arsenalOpened", {
    disableSerialization;
    _display = _this select 0;
    {
        ( _display displayCtrl _x ) ctrlSetText "Disabled";
        ( _display displayCtrl _x ) ctrlSetTextColor [ 1, 0, 0, 0.5 ];
        ( _display displayCtrl _x ) ctrlRemoveAllEventHandlers "buttonclick";
				
				_display displayAddEventHandler ["KeyDown", "if ((_this select 1) in [19,24,29,31]) then {true};"];
    } forEach [ 44146, 44147, 44150 ];
} ] call BIS_fnc_addScriptedEventHandler;



//*** F1 key:  Toggle the mission status hint message loop
sxf_fnc_handleKey_F1 = {
	_temp = player getVariable ['sxf_bLoopEnabled', false];
	if (_temp) then {hintSilent '';};
	playSound ( ['AddItemFailed', 'AddItemOK'] select !_temp );
	player setVariable ['sxf_bLoopEnabled', !_temp, true];
};
//*** F2 key:  Holster the primary weapon
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



//*** Assign special key bindings for this mission
waituntil {!(IsNull (findDisplay 46))};
(findDisplay 46) displayRemoveAllEventHandlers "KeyDown";
(findDisplay 46) displayAddEventHandler [
	"KeyDown", 
	{
			if ( (_this select 1) in ( (actionKeys 'User1') + [0x3b] ) ) then {call sxf_fnc_handleKey_F1;};
			if ( (_this select 1) in ( (actionKeys 'User2') + [0x3c] ) ) then {call sxf_fnc_handleKey_F2;};
			if ( (_this select 1) in ( (actionKeys 'User3') + [0x3d] ) ) then {call sxf_fnc_handleKey_F3;};
	}
];
[] spawn {	//display the helpful reminder early on into the mission
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
	"<br/><t align='left'>Revive Duration:</t><t align='right'>30 seconds</t>" +
	"<br/><t align='left'>Who Can Revive?:</t><t align='right'>Medics only (3x revive speed)</t>" +
	"<br/><t align='left'>First-Aid Kit required?:</t><t align='right'>No</t>" +
	"<br/><t align='left'>Medkit required?</t><t align='right'>Yes</t>" +
	"<br/><t align='left'>On Death:</t><t align='right'>Switch to Spectator</t>" +
	"<br/><t align='left'>AI Difficulty level:</t><t align='right'>4 of 7</t>" + 
	"<br/><br/><br/>"
);
