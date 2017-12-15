//*** Initial configurations for the mission (SERVERSIDE context)
sv_debug = !isMultiplayer || {count call BIS_fnc_listPlayers <= 1}; publicVariable "sv_debug";
missionComplete = false; publicVariable "missionComplete";

enableSentences false;
[ "Initialize" ] call BIS_fnc_dynamicGroups;



//*** Find the eligible buildings for each cache
_building1 = nearestBuilding [15936,17033];
_building2 = nearestBuilding [16002,17036];
_building3 = nearestBuilding [16215,17073];
_building4 = nearestBuilding [16010,16900];
_building5 = nearestBuilding [16075,16915];



//*** Configure and assemble the crates
_positionArray = [];
{
		_positionArray pushBack ([_x] call BIS_fnc_buildingPositions);
} forEach [_building1, _building2, _building3, _building4, _building5];

{
	_temp = _positionArray select _forEachIndex;
	_chosenPosition = _temp select (floor random count _temp);
	
	_x setPosATL _chosenPosition;

	_x addMPEventHandler
	[
		"MPKilled",
		{
			params ["_unit", "_killer"];
			[
				"Alert",
				[
					format [ "A cache has been destroyed! %1 remaining", ({alive _x} count [crate1, crate2, crate3, crate4, crate5]) - 1 ]
				]
			] call BIS_fnc_showNotification;
			
			switch (vehicleVarName _unit) do
			{
				case "crate1": { deleteMarker "marker-bldg1"; };
				case "crate2": { deleteMarker "marker-bldg2"; };
				case "crate3": { deleteMarker "marker-bldg3"; };
				case "crate4": { deleteMarker "marker-bldg4"; };
				case "crate5": { deleteMarker "marker-bldg5"; };
			};
		}
	];
	
	[ [_chosenPosition, _forEachIndex], {
		_markerList = ["marker-bldg1", "marker-bldg2", "marker-bldg3", "marker-bldg4", "marker-bldg5"];
		_tempMarker = _markerList select (_this select 1);
		if (side player isEqualTo blufor) then {
			_tempMarker setMarkerShapeLocal "ELLIPSE";
			_tempMarker setMarkerBrushLocal "Solid";
			_tempMarker setMarkerColorLocal "ColorEAST";
			_tempMarker setMarkerSizeLocal [15, 15];
			_varNamePos = (_this select 0) vectorAdd [floor random 3, floor random 3, 0];
			_tempMarker setMarkerPosLocal _varNamePos;
		} else {
			_tempMarker setMarkerShapeLocal "ICON";
			_tempMarker setMarkerTypeLocal "hd_flag";
			_tempMarker setMarkerTextLocal "Cache #" + str( (_this select 1) + 1 );
			_tempMarker setMarkerColorLocal "ColorEAST";
			_tempMarker setMarkerSizeLocal [0.6, 0.6];
			_tempMarker setMarkerPosLocal (_this select 0);
		};
	} ] remoteExec ["bis_fnc_call"];
	
	_temp = nil;
	_chosenPosition = nil;
} forEach [crate1, crate2, crate3, crate4, crate5];



//*** Assemble the weapon stashes
_stashLocations = [
	[16039.1,16834.3,0],
	[16139.7,16923.7,0],
	[15952.1,16963.2,0],
	[16056.7,17125.6,0]
];
_stashMarkerList =  ["stash-pos1", "stash-pos2"];
{
	_x allowDamage false;
	
	_chosenPosition = nil;
	_chosenPosition = _stashLocations select (floor random count _stashLocations);
	_x setPosATL _chosenPosition;
	_stashLocations = _stashLocations - [_chosenPosition];
	
	_tempStashMarker = _stashMarkerList select _forEachIndex;
	_tempStashMarker setMarkerShape "ICON";
	_tempStashMarker setMarkerType "hd_flag";
	_tempStashMarker setMarkerColor "ColorWEST";
	_tempStashMarker setMarkerSize [0.8, 0.8];
	_tempStashMarker setMarkerText "Weapon Stash!";
	_tempStashMarker setMarkerPos (getPosATL _x);	
} forEach [stash1, stash2];



//*** When a player dies, strip them of all their equipment so that nothing can be stolen!
addMissionEventHandler [
	"EntityKilled",
	{
		params ["_killed", "_killer", "_instigator", "_useEffects"];
		
		if (_killed isKindOf "Man") then {
			_killed setUnitLoadout [[],[],[],[(uniform _killed),[]],[(vest _killed),[]],[],(headgear _killed),(goggles _killed),[],["","","","","",""]];
		};
	}
];



//*** Start the mission countdown timer
currentTime = 900; publicVariable "currentTime";
sleep 0.1;	//wait until the mission actually begins
[] spawn 
{
	tenMinuteWarning = false;
	fiveMinuteWarning = false;
	twoMinuteWarning = false;
	while { (currentTime > 0) } do
	{
		currentTime = currentTime - 1;
		if (currentTime % 1 == 0) then
		{
			publicVariable "currentTime";
		};
		if (!tenMinuteWarning && {currentTime <= 600}) then	//ten minute warning!
		{
			tenMinuteWarning = true;			
			[
				"CountdownTimer",
				[
					"10 minutes"
				]
			] remoteExec ["BIS_fnc_showNotification"];
		};
		if (!fiveMinuteWarning && {currentTime <= 300}) then	//five minute warning!
		{
			fiveMinuteWarning = true;
			[
				"CountdownTimer",
				[
					"5 minutes"
				]
			] remoteExec ["BIS_fnc_showNotification"];
		};
		if (!twoMinuteWarning && {currentTime <= 120}) then	//five minute warning!
		{
			twoMinuteWarning = true;
			[
				"CountdownTimer",
				[
					"2 minutes"
				]
			] remoteExec ["BIS_fnc_showNotification"];
		};
		
		sleep 1;
	};
	
	missionComplete = true; publicVariable "missionComplete";
};