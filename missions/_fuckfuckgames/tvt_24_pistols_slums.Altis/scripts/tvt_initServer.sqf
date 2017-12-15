enableEnvironment false;

sv_debug = (count call BIS_fnc_listPlayers <= 1); publicVariable "sv_debug";

[ "Initialize" ] call BIS_fnc_dynamicGroups; //serverside initialization of the vanilla U-menu feature for group management



//*** Implement the TDM rule logic!
execVM "scripts\initTDMRules.sqf";



//*** When a player dies, strip them of all their equipment so that nothing can be stolen!
addMissionEventHandler [
	"EntityKilled",
	{
		params ["_killed", "_killer", "_instigator", "_useEffects"];
		
		if (_killed isKindOf "Man") then {
			deleteVehicle _killed;
		};
	}
];



//*** Initialize the looping hint message functionality
sxf_fnc_getPlayerStatusText = {
	_color = "#666666";	//dead color by default
	if (alive _this) then {
		_color = ["#FFFFFF", "#F1BD1D"] select ( lifeState _this isEqualTo "INCAPACITATED" );
	};
	
	
	
	format [
		"<t align='left' size='0.9'>  +  <t color='%1'>%2</t> </t><br/>", 
		_color, 
		name _this
	]
};
sxf_fnc_loopMessage = {	
	if (isNil "sv_playerTeamList") exitWith { 
		_output = "ERROR! sv_playerTeamList IS NOT DEFINED! (probably forgot to do execVM on the initTDMRules.sqf file?)";  
		_output 
	};
	
	_output = "";
	_livingPlayersMessage = "";
	_timerMessage = "";
	_enemyTeam = [opfor, blufor] select (side player isEqualTo blufor);
	
	_livingPlayersMessage = "<t align='left' size='1.3'>Players remaining:</t><br/>";
	
	if (count (sv_playerTeamList select 0) != 0) then {
		_livingPlayersMessage = _livingPlayersMessage + "<br/><br/>" + "> BLUE" + "<br/>";
		{ _livingPlayersMessage = _livingPlayersMessage + (_x call sxf_fnc_getPlayerStatusText); } forEach (sv_playerTeamList select 0);
	};
	if (count (sv_playerTeamList select 1) != 0) then {
		_livingPlayersMessage = _livingPlayersMessage + "<br/><br/>" + "> RED" + "<br/>";
		{ _livingPlayersMessage = _livingPlayersMessage + (_x call sxf_fnc_getPlayerStatusText); } forEach (sv_playerTeamList select 1);
	};
	if (count (sv_playerTeamList select 2) != 0) then {
		_livingPlayersMessage = _livingPlayersMessage + "<br/><br/>" + "> GREEN" + "<br/>";
		{ _livingPlayersMessage = _livingPlayersMessage + (_x call sxf_fnc_getPlayerStatusText); } forEach (sv_playerTeamList select 2);
	};
	if (count (sv_playerTeamList select 3) != 0) then {
		_livingPlayersMessage = _livingPlayersMessage + "<br/><br/>" + "> PURPLE" + "<br/>";
		{ _livingPlayersMessage = _livingPlayersMessage + (_x call sxf_fnc_getPlayerStatusText); } forEach (sv_playerTeamList select 3);
	};
	
	
	
	if (!isNil "sv_currentTime") then {
		_timerMessage = _timerMessage + "<t size='1.3'>Time remaining:</t><br/>";
		_timerMessage = _timerMessage + format["<t size='2' align='center' color='#F1BD1D'>%1m %2s</t>", floor (sv_currentTime/60), sv_currentTime%60];
	};

	
	
	_output = (
		"<br/><t align='left'>" +
		_timerMessage +
		"<br/><br/>" +
		_livingPlayersMessage +
		"<br/><br/></t>"
	);
	
	{	//show the mission info hint message only to the players who have their loop message turned ON
		if (_x getVariable ["sxf_bLoopEnabled", false]) then {
			(parseText _output) remoteExec ["hintSilent", _x];
		};
	} forEach (call BIS_fnc_listPlayers);
};



//*** Wait until the mission actually begins before continuing
waitUntil { time > 0 };



//*** Initialize the mission status hint message loop
[ "itemAdd", [
	"loopMessage", { call sxf_fnc_loopMessage; },
	1, "seconds", {
		{_x getVariable ["sxf_bLoopEnabled", false]} count (call BIS_fnc_listPlayers) > 0  
	} 
] ] call BIS_fnc_loop;



//*** Initialize the countdown timer for all players
sv_currentTime = 5*60;
[ "itemAdd", [ 
	"countdownTimer", {		
		sv_currentTime = sv_currentTime - 1;
		if (sv_currentTime isEqualTo 0) then {
			sv_currentTime = nil;
			"EveryoneLost" call BIS_fnc_endMissionServer;
		};
	}, 
	1, "seconds", {
		!isNil "sv_currentTime" && {sv_currentTime >= 0}
	}
] ] call BIS_fnc_loop; 