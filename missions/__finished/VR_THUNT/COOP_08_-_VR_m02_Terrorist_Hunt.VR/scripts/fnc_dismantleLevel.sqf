//CONTEXT: server-side
if (!roundInProgress && activateAO) exitWith {hint "ERROR-- fnc_dismantleLevel.sqf was somehow called while a round was NOT already in progress or while activateAO was being handled!!";};

roundInProgress = false; publicVariable "roundInProgress";
"" remoteExec ["hintSilent", -2];

currentMissionTimeRemaining = 0; publicVariable "currentMissionTimeRemaining";

{	//get rid of the AI and reset the enemyUnitList array
	deleteVehicle _x;
} forEach enemyUnitList;
enemyUnitList = [];

{	//respawn players, deactivate Spectator UI, and teleport them into the proper spawn location
	//how do I respawn players???
	["Terminate"] call BIS_fnc_EGSpectator;
	_x allowDamage false;
	_x setPosATL (getMarkerPos "respawn_west");
	_x setDir (markerDir "respawn_west");
	_x allowDamage true;
} forEach (call BIS_fnc_listPlayers);


if (!isNil "sv_debug" && {sv_debug}) then
{
	playSound "FD_Start_F";
	hint "fnc_dismantleLevel COMPLETE";
};