enableSaving [false, false];
enableSentences false;

whiteBoard_1 setObjectTextureGlobal [0, "images\whiteBoard.jpg"];
billBoard_1 setObjectTextureGlobal [0, "images\goon-logo.jpg"];

sv_debug = false; publicVariable "sv_debug";
tempDebugVer = 1; publicVariable "tempDebugVer";

sxf_fnc_prepareLevel = compile preprocessFileLineNumbers "scripts\fnc_prepareLevel.sqf";
sxf_fnc_dismantleLevel = compile preprocessFileLineNumbers "scripts\fnc_dismantleLevel.sqf";

sxf_fnc_handleMissionFailed = compile preprocessFileLineNumbers "scripts\fnc_handleMissionFailed.sqf"; publicVariable "sxf_fnc_handleMissionFailed";

missionComplete = false; publicVariable "missionComplete";
roundInProgress = false; publicVariable "roundInProgress";
activateAO = false; publicVariable "activateAO";

enemyUnitList = []; publicVariable "enemyUnitList";
enemyGroupList = [];
for "_i" from 1 to (paramsArray select 0) do
{
	enemyGroupList pushBack (createGroup opfor);
};
publicVariable "enemyGroupList";

//players by default are in the passive group and only are part of the active group when in the AO (added automatically via whiteBoard action in initPlayerLocal.sqf)
activePlayerGroup = (createGroup blufor); publicVariable "activePlayerGroup";	
passivePlayerGroup = (createGroup blufor); publicVariable "passivePlayerGroup";

missionTimeLimit = 60 * (paramsArray select 1);
currentMissionTimeRemaining = 0; publicVariable "currentMissionTimeRemaining";

currentRoundCount = 0; publicVariable "currentRoundCount";

currentPlayersInTheAO = []; publicVariable "currentPlayersInTheAO";


//parse and assign the appropriate unit spawn markers for both players and AI
enemySpawnMarkerList = [];
playerSpawnMarkerList = [];
{
	_temp = (_x splitString "_") select 0;	//parse all markers based on their starting prefix
	switch (_temp) do
	{
		case "enemySpawn": { enemySpawnMarkerList pushBack _x; };
		case "playerSpawn": { playerSpawnMarkerList pushBack _x; };
	};
} forEach allMapMarkers;
publicVariable "playerSpawnMarkerList";