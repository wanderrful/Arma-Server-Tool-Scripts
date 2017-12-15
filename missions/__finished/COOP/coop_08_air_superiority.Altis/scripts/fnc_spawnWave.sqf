//if (sv_debug) then { hint "fnc_spawnWave.sqf called!"; };



_grp = createGroup opfor;

//spawn the units
"O_Fighter_Pilot_F" createUnit [ [0,0,0], _grp, "", 0.5, "LIEUTENANT" ];
"O_Fighter_Pilot_F" createUnit [ [0,0,0], _grp, "", 0.5, "LIEUTENANT" ];
"O_Fighter_Pilot_F" createUnit [ [0,0,0], _grp, "", 0.5, "LIEUTENANT" ];
"O_Fighter_Pilot_F" createUnit [ [0,0,0], _grp, "", 0.5, "LIEUTENANT" ];
"O_Fighter_Pilot_F" createUnit [ [0,0,0], _grp, "", 0.5, "LIEUTENANT" ];

//choose where the wave will spawn
_markerList = ["spawn_pos_1", "spawn_pos_2", "spawn_pos_3", "spawn_pos_4", "spawn_pos_5"];
_chosenMarker = _markerList select (floor random (count _markerList));
_jetSpawnPos = getMarkerPos _chosenMarker;

//display the temporary alert marker
_chosenMarker spawn {
	_this setMarkerType "hd_warning";
	sleep 15;
	_this setMarkerType "Empty";
};

//spawn the jets
{
	_jetSpawnPos set [0, (_jetSpawnPos select 0) + (random 512)];
	_jetSpawnPos set [1, (_jetSpawnPos select 1) + (random 512)];
	_jetSpawnPos set [2, 1000 + 100*(random 5)];
	_jet = createVehicle ["O_Plane_Fighter_02_F", _jetSpawnPos, [], 500, "FLY"];
	_jet allowDamage false;
	_jet setDir 45;
	_jet setPosASL _jetSpawnPos;
	sv_aircraftList pushBack _jet;
	_jet call sxf_fnc_configureMarker;
	_x moveInDriver _jet;
	_jet allowDamage true;
} forEach (units _grp);

//issue a waypoint order to this new group of units
_destinationList = ( (sv_radarList call BIS_fnc_arrayShuffle) - [RADAR_04] );
{
	if (alive _x) then {
		_waypoint = _grp addWaypoint [missionNamespace getVariable [( (vehicleVarName _x) + "_dummy" ), _x], 0];
		_waypoint setWaypointCombatMode "RED";
		_waypoint setWaypointBehaviour "COMBAT";
		_waypoint setWaypointType "DESTROY";
		_waypoint setWaypointCompletionRadius 1500;
	};
} forEach _destinationList;

["TaskUpdated", ["", "Enemy wave inbound!"]] remoteExec ["BIS_fnc_showNotification"];
