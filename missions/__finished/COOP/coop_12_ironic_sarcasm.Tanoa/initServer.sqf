//*** Define the win and lose condition logic
sxf_fnc_handleMissionCompleted = {
	"MissionSuccess" remoteExec ["BIS_fnc_showNotification"];
	"MissionSuccessObjectiveCompleted" remoteExec ["playSound"];
	"EveryoneWon" call BIS_fnc_endMissionServer;
	( parseText format["<br/><br/><t size='1.5' color='#E28014' align='center'>Mission Success</t><br/>Objective Completed<br/><br/><br/><br/>", nil] ) remoteExec ["hint"];
};
sxf_fnc_handleMissionFailed = {
	if (_this) then { //true->team wiped out
		"MissionFail" remoteExec ["BIS_fnc_showNotification"];
		"MissionFailureYourTeamWasWipedOut" remoteExec ["playSound"];
		( parseText format["<br/><br/><t size='1.5' color='#E28014' align='center'>Mission Failure</t><br/>Your team was wiped out.<br/><br/><br/><br/>", nil] ) remoteExec ["hint"];
	} else { //false->hostage killed
		"MissionFailHostageKilled" remoteExec ["BIS_fnc_showNotification"];
		"MissionFailureYourTeamWasWipedOut" remoteExec ["playSound"];
		( parseText format["<br/><br/><t size='1.5' color='#E28014' align='center'>Mission Failure</t><br/>A hostage was killed.<br/><br/><br/><br/>", nil] ) remoteExec ["hint"];
	};
	"EveryoneLost" call BIS_fnc_endMissionServer;
};

[ "itemAdd", [ 
	"checkMissionCompleted", {
		true call sxf_fnc_handleMissionCompleted;
		["itemRemove", ["checkMissionCompleted"]] call BIS_fnc_loop;
	}, 
	1, "seconds", { opfor countSide allUnits <= 0 }
] ] call BIS_fnc_loop; 
[ "itemAdd", [ 
	"checkMissionFailed", {
		true call sxf_fnc_handleMissionFailed; 
		["itemRemove", ["checkMissionFailed"]] call BIS_fnc_loop;
	}, 
	1, "seconds", { !sv_debug && {blufor countSide allUnits <= 0} }
] ] call BIS_fnc_loop;

//*** Define the aircraft repair, rearm, and refuel stations' functionality
sxf_fnc_stripAircraft = { //DEPRECATED
	//_this must be the aircraft vehicle itself
	{	
		if (_x != "CMFlareLauncher") then { //i don't know how to re-add this back into the chaff slot for some reason... :'c
			_this removeWeaponTurret [_x, [-1]]; 
		};
	} forEach (_this weaponsTurret [-1]);
	{
		_this removeMagazineTurret [_x, [-1]];
	} forEach (_this magazinesTurret [-1]);
};
sxf_fnc_equipAircraft = {
	_vehicle = _this;
	
	_Buzzard_Loadout_AA = ["PylonRack_1Rnd_AAA_missiles","PylonRack_1Rnd_AAA_missiles","PylonRack_1Rnd_AAA_missiles","PylonWeapon_300Rnd_20mm_shells","PylonRack_1Rnd_AAA_missiles","PylonRack_1Rnd_AAA_missiles","PylonRack_1Rnd_AAA_missiles"];
	_Buzzard_Loadout_Bomber = ["","","PylonMissile_1Rnd_Bomb_04_F","PylonWeapon_300Rnd_20mm_shells","PylonMissile_1Rnd_Bomb_04_F","",""];
	
	private _pylons = _Buzzard_Loadout_AA;
	private _pylonPaths = (configProperties [configFile >> "CfgVehicles" >> typeOf _vehicle >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply {getArray (_x >> "turret")};
	{ _vehicle removeWeaponGlobal getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon") } forEach getPylonMagazines _vehicle;
	{ _vehicle setPylonLoadOut [_forEachIndex + 1, _x, true, _pylonPaths select _forEachIndex] } forEach _pylons;
};
sxf_fnc_refuelAircraft = {
	_this setFuel 0.33;
};
sxf_fnc_repairAircraft = {
	_this setDamage 0;
};
sxf_fnc_handleRearmAircraft = {
	//_this is meant to be thisList according to the trigger that called this function
	if (! ((_this select 0) isKindOf "Plane")) exitWith {};
	_aircraft = _this select 0;
	["TaskUpdated", ["", "Rearm process initiated!"]] remoteExec ["BIS_fnc_showNotification", driver _aircraft];
	//_aircraft call sxf_fnc_stripAircraft;
	sleep 3;
	_aircraft call sxf_fnc_equipAircraft;
	["TaskSucceeded", ["", "Rearm process completed!"]] remoteExec ["BIS_fnc_showNotification", driver _aircraft];
};
sxf_fnc_handleRefuelAircraft = {
	//_this is meant to be thisList according to the trigger that called this function
	if (! ((_this select 0) isKindOf "Plane")) exitWith {};
	_aircraft = _this select 0;
	["TaskUpdated", ["", "Refuel process initiated!"]] remoteExec ["BIS_fnc_showNotification", driver _aircraft];
	sleep 3;
	_aircraft call sxf_fnc_refuelAircraft;
	["TaskSucceeded", ["", "Refuel process completed!"]] remoteExec ["BIS_fnc_showNotification", driver _aircraft];
};
sxf_fnc_handleRepairAircraft = {
	//_this is meant to be thisList according to the trigger that called this function
	if (! ((_this select 0) isKindOf "Plane")) exitWith {};
	_aircraft = _this select 0;
	["TaskUpdated", ["", "Repair process initiated!"]] remoteExec ["BIS_fnc_showNotification", driver _aircraft];
	sleep 3;
	_aircraft call sxf_fnc_repairAircraft;
	["TaskSucceeded", ["", "Repair process completed!"]] remoteExec ["BIS_fnc_showNotification", driver _aircraft];
};
trg_rearmZone setTriggerStatements ["this", "thisList spawn sxf_fnc_handleRearmAircraft", ""];
trg_refuelZone setTriggerStatements ["this", "thisList spawn sxf_fnc_handleRefuelAircraft", ""];
trg_repairZone setTriggerStatements ["this", "thisList spawn sxf_fnc_handleRepairAircraft", ""];
{	//initialize the jets
	//_x call sxf_fnc_stripAircraft;
	_x call sxf_fnc_equipAircraft;
	_x call sxf_fnc_refuelAircraft;
	_x call sxf_fnc_repairAircraft;
} forEach [jet_1, jet_2];



//*** Define the enemy aircraft wave spawning logic
sxf_fnc_createEnemyWave = {};
sxf_fnc_beginSpawningWaves = {};