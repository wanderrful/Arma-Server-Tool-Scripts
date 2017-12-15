//*** Define the initial settings
sv_debug = (count call BIS_fnc_listPlayers <= 1); publicVariable "sv_debug";
[ "Initialize" ] call BIS_fnc_dynamicGroups; //serverside initialization of the vanilla U-menu feature for group management
enableSentences false;



//*** Define the utility functions
sxf_fnc_getEntitiesByPrefix = {
	_tempList = [];
	_i = count _tempList;
	while { _i = _i + 1; !isNil (_this + str _i) } do {
		_tempList pushBack ( missionNamespace getVariable [(_this + str _i), objNull] );
	};
	_tempList
};
sxf_fnc_refitHelicopter = compileFinal preprocessFile "scripts\fn_refitHelicopter.sqf";



//*** When a unit dies, strip all of its equipment so that nothing can be looted!
addMissionEventHandler [
	"EntityKilled",
	{
		params ["_killed", "_killer", "_instigator", "_useEffects"];
		
		if (_killed isKindOf "Man") then {
			_killed setUnitLoadout [[],[],[],[(uniform _killed),[]],[(vest _killed),[]],[],(headgear _killed),(goggles _killed),[],["","","","","",""]];
		};
	}
];



//*** Configure the win/fail conditions
sxf_fnc_bMissionCompleted = { !alive hvt || { opfor countSide allUnits <= 0 } };
sxf_fnc_bMissionFailed = { independent countSide allUnits <= 0 };
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
[ "itemAdd", [ "checkMissionCompleted", {
		if (call sxf_fnc_bMissionCompleted) then {
			true call sxf_fnc_handleMissionCompleted;
			["itemRemove", ["checkMissionCompleted"]] call BIS_fnc_loop;
		}
	}, 
	1, "seconds"		
] ] call BIS_fnc_loop; 
[ "itemAdd", [ "checkMissionFailed", {
		if (call sxf_fnc_bMissionFailed) then {
			true call sxf_fnc_handleMissionFailed; 
			["itemRemove", ["checkMissionFailed"]] call BIS_fnc_loop;
		};
	}, 
	1, "seconds"
] ] call BIS_fnc_loop;



//*** React to the destruction of the tower_1 side mission
[ "itemAdd", [ 
	"checkTowerDestroyed", {
		if (!alive tower_1) then {
			"ObjectiveCompleted" remoteExec ["BIS_fnc_showNotification"];
			"ObjectiveCompleted" remoteExec ["playSound"];
			["itemRemove", ["checkTowerDestroyed"]] call BIS_fnc_loop;
		};
	}, 
	1, "seconds"
] ] call BIS_fnc_loop;



/*
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
*/



//*** Configure the helicopter's refit trigger functionality
trg_helicopterRefitZone setTriggerStatements ["this && { isTouchingGround (thisList select 0) }", "thisList spawn sxf_fnc_refitHelicopter", ""];



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