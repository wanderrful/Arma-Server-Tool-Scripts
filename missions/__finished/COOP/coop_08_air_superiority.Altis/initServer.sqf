/*
	TODO: respawned aricraft need to have their things setup
	TOOD: add a player respawn for the carrier!
	DONE: the refit script doesn't work online! (locality!)
		- the setvelocity doesn't work
		- the weapons are all stripped from the aircraft and the ammo is not changed at all!
	TODO: when a unit touches the ground, they should auto-die (except for carrier)
	TODO: do an addaction on a box so that ATCs can manually spawn the waves
	TODO: add heat-seeker missles to the jets (6 heat seekers, 8 radars)
	TODO: make the enemy aircraft different ones!  (not all the same plane)
	TODO: the radar aircraft markers don't work properly when jets are killed or when players respawn!
		- add an "EntityRespawned" mission event handler.  if it's a plane that's been respawned... assign the marker to the new jet using setVariable!
*/


//*** Define the initial settings
sv_debug = (count call BIS_fnc_listPlayers <= 1); publicVariable "sv_debug";
[ "Initialize" ] call BIS_fnc_dynamicGroups; //serverside initialization of the vanilla U-menu feature for group management
enableSentences false;

//*** Define the special mission variables
sv_aircraftList = [jet_1, jet_2, jet_3, jet_4, jet_5, jet_6, jet_7, jet_8];
sv_aircraftMarkerList = [];
sv_radarList = [RADAR_01, RADAR_02, RADAR_03, RADAR_04];
sv_waveCount = 0;
sv_MaxWaveCount = 5;
sv_IntervalBetweenWaves = 10*60;
sv_missionComplete = false;
sv_missionFailed = false;
//sv_opforGroup = createGroup opfor;



//*** Define the special mission functions
sxf_fnc_spawnWave = compileFinal preprocessFile "scripts\fnc_spawnWave.sqf";
sxf_fnc_configureMarker = compileFinal preprocessFile "scripts\fnc_configureMarker.sqf";



//*** initialize the "radar" system
{ 
	_x call sxf_fnc_configureMarker;
	//_x call sxf_fnc_refitAircraft;
} forEach sv_aircraftList;



waitUntil { time > 0 };



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

[ "itemAdd", [ "checkMissionCompleted", {
		true call sxf_fnc_handleMissionCompleted;
		["itemRemove", ["checkMissionCompleted"]] call BIS_fnc_loop;
	}, 
	1, "seconds", { sv_missionComplete }
] ] call BIS_fnc_loop; 
[ "itemAdd", [ "checkMissionFailed", {
		true call sxf_fnc_handleMissionFailed; 
		["itemRemove", ["checkMissionFailed"]] call BIS_fnc_loop;
	}, 
	1, "seconds", {
		!sv_debug && {
			blufor countSide allUnits <= 0 || { sv_missionFailed } 
		}
	}
] ] call BIS_fnc_loop;



//*** Radar Loop
[ "itemAdd", [ "RadarLoop", {
			{
				//update the position of all aircraft markers
				_markerIndex = _x getVariable ["sxf_markerIndex", -1];				
				if (_markerIndex != -1) then {
					_marker = sv_aircraftMarkerList select _markerIndex;
					_marker setMarkerPos (position _x);
					
					//for each aircraft, determine if it is in radar range
					_aircraft = _x;
					{
						scopeName "RadarScope";
						_radarZoneMarker = (vehicleVarName _x) + "_zone"; 
						_temp_radarColor = "ColorGreen";
						if (alive _x) then {
							if (_aircraft inArea _radarZoneMarker && {isEngineOn _aircraft} ) then {
								//if it is radar range, show the marker
								if (getMarkerColor _marker isEqualTo "ColorRed" ) then {
									_temp_radarColor = "ColorRed";
								};
								_marker setMarkerType "hd_arrow";
								_marker setMarkerDir (1 + (getDir _aircraft));	//adjust for marker's direction offset
								_marker setMarkerText ( str floor (getPosASL _aircraft select 2) + "m" );
								breakOut "RadarScope";
							} else {
								//if it is not in radar range, hide the marker
								_marker setMarkerType "Empty";
								_marker setMarkerText "";
							}
						} else {
							_temp_radarColor = "ColorBlack";
							_radarMarker = (vehicleVarName _x) + "_marker";
							_radarMarker setMarkerColor "ColorBlack";
							_radarMarker setMarkerText "DESTROYED";

						};
						_radarZoneMarker setMarkerColor _temp_radarColor;
/*						if (sv_debug) then { 
							_marker setMarkerType "hd_arrow"; 
							_marker setMarkerDir (3 + (getDir _aircraft));	//adjust for marker's direction offset
							_marker setMarkerText ( str floor (getPosASL _aircraft select 2) + "m" );
						};
*/					} forEach sv_radarList;
					
					if (!alive _x) then {
						deleteMarker _marker;
						sv_aircraftMarkerList = sv_aircraftMarkerList - [_marker];
						sv_aircraftList = sv_aircraftList - [_x];
					};
				};
			} forEach sv_aircraftList;
		},
		2, "seconds"
	]
] call BIS_fnc_loop;



//*** Countdown Timer / Wave Loop
sv_currentTime = 5*60;
[ "itemAdd", [ 
	"SpawnWave", {		
		if (sv_currentTime > 0) then {
			sv_currentTime = sv_currentTime - 1; 
		} else {	
			if (sv_waveCount < sv_MaxWaveCount) then {
				sv_waveCount = sv_waveCount + 1;
				[] spawn sxf_fnc_spawnWave;
				sv_currentTime = sv_IntervalBetweenWaves;
			} else {
				if (opfor countSide allUnits < 0) then {
					true call sxf_fnc_handleMissionCompleted;
					["itemRemove", ["SpawnWave"]] call BIS_fnc_loop;
				}
			}
			//let the players know a wave has spawned?
			//maybe via BIS_fnc_showNotification?
		};
	}, 
	1, "seconds", {
		!isNil "sv_currentTime" && {sv_currentTime >= 0}
	}
] ] call BIS_fnc_loop; 



//*** Radar Destruction handler
addMissionEventHandler ["EntityKilled", {
	params ["_killed", "_killer", "_instigator", "_useEffects"];
	if (_killed in sv_radarList) then {
		["TaskFailed", ["", "Radar destroyed!"]] remoteExec ["BIS_fnc_showNotification"];

		if ( {alive _x} count sv_radarList isEqualTo 1) then {
			sv_missionFailed = true;
		};
	};
}];



//*** Configure the looping hint message of which players can opt-in or out as they please.
sxf_fnc_loopMessage = {	
	_output = "";
	
	_enemyCountMessage = format [ "<br/><t size='1.5'><t align='left'>Jets remaining:</t> <t color='#E28014' align='right'>%1</t></t><br/>", opfor countSide allUnits ];
	_timerMessage = "";

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

	if (sv_waveCount < 5) then {
		_timerMessage = _timerMessage + format["<t size='1.3'>Time to next wave (%1 of %2):</t><br/>", sv_waveCount, sv_MaxWaveCount];
		_timerMessage = _timerMessage + format["<t size='2' align='center' color='#F1BD1D'>%1m %2s</t>", floor (sv_currentTime/60), sv_currentTime%60];
	} else {
		_timerMessage = _timerMessage + format["No more waves: eliminate all hostile jets!"];
	};
	
	_output = (
		_enemyCountMessage + 
		"<br/><br/>" +
		_timerMessage +
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
[ "itemAdd", [ "loopMessage", {
		call sxf_fnc_loopMessage; 
	}, 1, "seconds", {
		{_x getVariable ["sxf_bLoopEnabled", false]} count (call BIS_fnc_listPlayers) > 0  
	} 
] ] call BIS_fnc_loop;



//*** addAction to the jets when they respawn
addMissionEventHandler [ "EntityRespawned", {
	params ["_newUnit", "_oldUnit"];

	if (_newUnit isKindOf "Air") then {
		[
			_newUnit,
			[
				"Get in! (bypass DLC)",
				{ player moveInDriver _newUnit; }
			]
		] remoteExec ["addAction"];
	};
}];