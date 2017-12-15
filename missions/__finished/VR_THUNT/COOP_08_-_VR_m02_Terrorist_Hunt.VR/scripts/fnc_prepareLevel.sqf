//CONTEXT: server-side
if (roundInProgress && !activateAO) exitWith {hint "ERROR -- fnc_prepareLevel.sqf was somehow called while a round was already in progress and activateAO was already set!";};

currentMissionTimeRemaining = missionTimeLimit; publicVariable "currentMissionTimeRemaining";
currentRoundCount = currentRoundCount + 1; publicVariable "currentRoundCount";

currentPlayersInTheAO = [];

_potentialSpawnLocations = [];
_potentialSpawnLocations = enemySpawnMarkerList; 
enemyUnitList = [];

_potentialSpawnLocations call BIS_fnc_arrayShuffle;

_unitsToSpawn = paramsArray select 0; //desired enemy count

for "_i" from 1 to _unitsToSpawn do
{	//create the AI units for the mission
	_chosenSpawnLocation = _potentialSpawnLocations select (floor random count _potentialSpawnLocations);
	_potentialSpawnLocations = _potentialSpawnLocations - [_chosenSpawnLocation];

	_grp = enemyGroupList select (opfor countSide allUnits);
	_unit = _grp createUnit
	[
		"O_G_Soldier_F",
		getMarkerPos _chosenSpawnLocation,
		[],
		0,
		"NONE"
	];

	_unit setCombatMode "RED";
	_unit setBehaviour "SAFE";
	_unit setFormDir (markerDir _chosenSpawnLocation);
	
	//roll 1d5
	_roll1d5 = (round (random 100)) % 5;
	if (_roll1d5 == 4) then
	{
		//create a waypoint path cycle for this unit to follow!
		_chosenPatrolDestination = _potentialSpawnLocations select (floor random count _potentialSpawnLocations);
		_waypointTarget = _grp addWaypoint [getMarkerPos _chosenSpawnLocation, 0];
		_waypointTarget setWaypointType "MOVE";
		_waypointTarget = _grp addWaypoint [getMarkerPos _chosenPatrolDestination, 1];
		_waypointTarget setWaypointType "CYCLE";
	};
	
	{
		_unit disableAI _x;
	} forEach ["TARGET", "SUPPRESSION"];
	
	removeAllWeapons _unit;
	removeAllItemsWithMagazines _unit;
	_unit removeWeapon (primaryWeapon _unit);
	[_unit, "SMG_02_F", 10] call BIS_fnc_addWeapon; 
	
	_unit addEventHandler
	[	//delete the AI the moment it is killed!
		"Killed",
		{
			deleteVehicle (_this select 0);
		}
	];
	_unit addEventHandler
	[	//prevent the AI units from going prone!
		"AnimChanged",
		{
			params ["_unit", "_anim"];
			if (_anim find "Ppne" != -1) then
			{
				_unit setUnitPos "UP";
			};
		}
	];
	
	enemyUnitList pushBack _unit;
};
publicVariable "enemyGroupList";

if (!isNil "sv_debug" && {sv_debug}) then
{
	playSound "FD_Start_F";
	hint "fnc_prepareLevel COMPLETE";
};

roundInProgress = true; publicVariable "roundInProgress";
activateAO = false; publicVariable "activateAO";

["sxf_MissionStart"] remoteExec ["BIS_fnc_showNotification"];

//start the mission timer!
while {roundInProgress && currentMissionTimeRemaining > 0} do
{
	currentMissionTimeRemaining = currentMissionTimeRemaining - 1;
	publicVariable "currentMissionTimeRemaining";
	
	sleep 1;
};