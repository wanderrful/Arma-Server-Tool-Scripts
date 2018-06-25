//*** Define the initial settings
sv_debug = (count call BIS_fnc_listPlayers <= 1); publicVariable "sv_debug";

sxf_fnc_getEntitiesByPrefix = {
	_tempList = [];
	_i = count _tempList;
	while { _i = _i + 1; !isNil (_this + str _i) } do {
		_tempList pushBack ( missionNamespace getVariable [(_this + str _i), objNull] );
	};
	_tempList
};

sv_objectives = "obj_" call sxf_fnc_getEntitiesByPrefix;
[ "Initialize" ] call BIS_fnc_dynamicGroups; //serverside initialization of the vanilla U-menu feature for group management
enableSentences false;
{ _x disableTIEquipment true; } forEach [strider_1, strider_2];



//*** Configure the win/fail conditions
sxf_fnc_bMissionCompleted = { independent countSide allUnits <= 0 || { {alive _x} count [obj_1, obj_2, obj_3, obj_4] <= 0 } };
sxf_fnc_bMissionFailed = { opfor countSide allUnits <= 0 };
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
		if (call sxf_fnc_bMissionCompleted) then {
			true call sxf_fnc_handleMissionCompleted;
			["itemRemove", ["checkMissionCompleted"]] call BIS_fnc_loop;
		}
	}, 
	1, "seconds"		
] ] call BIS_fnc_loop; 
[ "itemAdd", [ 
	"checkMissionFailed", {
		if (call sxf_fnc_bMissionFailed) then {
			true call sxf_fnc_handleMissionFailed; 
			["itemRemove", ["checkMissionFailed"]] call BIS_fnc_loop;
		};
	}, 
	1, "seconds"
] ] call BIS_fnc_loop;



//*** Configure the waypoint triggers
sxf_fnc_handleWaypointReached = {	
	//_this should be the trigger that is calling this function
	"WaypointReached" remoteExec ["BIS_fnc_showNotification"];
	"ObjectiveCompleted" remoteExec ["playSound"];
	deleteVehicle _this;
};
{ //initialize the waypoint triggers
	_x setTriggerStatements ["this", "thisTrigger call sxf_fnc_handleWaypointReached", ""];
} forEach [trg_wp_1, trg_wp_2, trg_wp_3];



//*** Configure the aircraft rearm, repair, and refuel triggers
sxf_fnc_stripAircraft = {
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
	_this addWeaponTurret ["gatling_30mm", [-1]]; 
	_this addMagazineTurret ["250Rnd_30mm_APDS_shells", [-1]];
	_this addWeaponTurret ["Rocket_04_HE_Plane_CAS_01_F", [-1]]; 
	//_this addMagazineTurret ["7Rnd_Rocket_04_HE_F", [-1]];
	_this setMagazineTurretAmmo ["7Rnd_Rocket_04_HE_F", 2, [-1]];
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
	_aircraft call sxf_fnc_stripAircraft;
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
	_x call sxf_fnc_stripAircraft;
	_x call sxf_fnc_equipAircraft;
	_x call sxf_fnc_refuelAircraft;
	_x call sxf_fnc_repairAircraft;
} forEach [jet_1, jet_2];



//*** Configure the looping hint message of which players can opt-in or out as they please.
sxf_fnc_loopMessage = {	
	_output = "";
	
	_enemyCountMessage = format [ "<br/><t size='1.5'><t align='left'>Enemies remaining:</t> <t color='#E28014' align='right'>%1</t></t><br/>", opfor countSide allUnits ];
	
	_livingPlayersMessage = "<t align='left' size='1.3'>Players remaining:</t><br/>";
	{
		if (isPlayer _x && {! ( str side _x isEqualTo "LOGIC" ) }) then {
			_color = "#666666";	//dead color by default
			if (alive _x) then {
				_color = ["#FFFFFF", "#F1BD1D"] select ( lifeState _x isEqualTo "INCAPACITATED" );
			};
			_livingPlayersMessage = _livingPlayersMessage + format [
				"<t align='left'>  +  <t color='%1'>%2</t><br/>", 
				_color, 
				name _x
			];
		};
	} forEach ( [allUnits, call BIS_fnc_listPlayers] select isMultiplayer );
	
	_output = (
		_enemyCountMessage + 
		"<br/><br/>" +
		_livingPlayersMessage +
		"<br/><br/>"
	);
	
	{	//show the mission info hint message only to the players who have their loop message turned ON
		if (_x getVariable ["sxf_bLoopEnabled", false]) then {
			(parseText _output) remoteExec ["hintSilent", _x];
		};
	} forEach (call BIS_fnc_listPlayers);
};
[ "itemAdd", [ "loopMessage", { call sxf_fnc_loopMessage; }, 1, "seconds", {  {_x getVariable ["sxf_bLoopEnabled", false]} count (call BIS_fnc_listPlayers) > 0  } ] ] call BIS_fnc_loop;