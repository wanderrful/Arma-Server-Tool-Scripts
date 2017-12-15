/*
 *	Holdout
 *		Original by Staticky,
 *		Revised and modded by /u/tagus, 2 November 2014
 *	
 */

// [240,0,20,"spawn_north","spawn_east","spawn_west","spawn_south","town"] execVM "holdout.sqf";
//[timebetweenwaves,startingwavenumber,decreasetimeeverywave,"spawnmarker1","spawnmarker2","spawnmarker3","spawnmarker4","attackmarker"] execVM "holdout.sqf";

//VANILLA VER.

if (!isServer) exitWith {};

_startTime		= _this select 0;
_startingWave		= _this select 1;
_decreaseTime		= _this select 2;
_spawnMarker1		= _this select 3;
_spawnMarker2		= _this select 4;
_spawnMarker3		= _this select 5;
_spawnMarker4		= _this select 6;
_attackMarker		= _this select 7;

if (wave == 0) then {
	[
		{
			hint parseText "<t size='1.25'>The game will begin in:<br /> 15 seconds</t><br /><br />(tip: A message will appear in the bottom left chat area when a new wave has spawned)";
		}, 
		"bis_fnc_spawn"
	] call BIS_fnc_mp;
};

sleep 15; //time till first wave spawns
 
private ["_spawning","_timer","_wave","_type","_grp","_grpType","_sideArray","_grpRandom","_infGrp","_motGrp","_mechGrp","_mechgrpno","_motgrpno","_waypoint1","_smallinf","_midinf","_largeinf","_tech","_moto"];


_timer = _startTime; //starting time between waves
_wave = _startingWave;  //starting wave number

spawning = 1; //can be edited via debug "spawning = 0" exec on server

while {spawning > 0} do 
{ 
	if (_timer < 45) then 
	{
		_timer = _timer - _decreaseTime;
	};

	_wave = _wave + 1; //for local wave spawning
	wave = wave + 1; //for global wave counting

	_side = east;
	_sideArray = ["Indep", "IND_F"];
	_grpType = ["Infantry", "Motorized"];
	_smallinf = ["HAF_InfTeam","HAF_InfTeam","HAF_InfTeam","HAF_InfTeam_AT"] call BIS_fnc_selectRandom;
	_midinf = ["HAF_InfTeam_AT","HAF_InfSquad","HAF_InfSquad","HAF_InfTeam","HAF_InfTeam_AT"] call BIS_fnc_selectRandom;
	_largeinf = ["HAF_InfSquad","HAF_InfSquad_Weapons","HAF_InfSquad","HAF_InfSquad","HAF_InfSquad_Weapons"] call BIS_fnc_selectRandom;
	_moto = ["HAF_SniperTeam"] call BIS_fnc_selectRandom;
	_tech = ["HAF_MotInf_Team"] call BIS_fnc_selectRandom;
	_spawnPos = [_spawnMarker1,_spawnMarker2,_spawnMarker3,_spawnMarker4] call BIS_fnc_selectRandom;
	_typeList = [];

	sleep 1;

	if ( _wave <= 5) then 
	{
		_type = [_smallinf, _midinf, _smallinf, _smallinf] call BIS_fnc_selectRandom;
	};
	if ( _wave > 5 && {_wave <= 12}) then 
	{
		_type = [_midinf, _midinf, _largeinf, _midinf, _tech] call BIS_fnc_selectRandom;
	};
	if ( _wave > 12) then 
	{
		_type = [_largeinf, _largeinf, _tech, _largeinf, _moto] call BIS_fnc_selectRandom;
	};

	sleep 1;

	switch (_type) do {
		case _smallinf:
		{
			_grp = 
			[
				getMarkerPos _spawnPos, 
				_side, 
				(configFile >> "CfgGroups" >> (_sideArray select 0) >> (_sideArray select 1) >> (_grpType select 0) >> _type)
			] call BIS_fnc_spawnGroup;
		};
		case _largeinf: 
		{
			_grp = 
			[
				getMarkerPos _spawnPos, 
				_side, 
				(configFile >> "CfgGroups" >> (_sideArray select 0) >> (_sideArray select 1) >> (_grpType select 0) >> _type)
			] call BIS_fnc_spawnGroup;
		};
		case _midinf: 
		{
			_grp = 
			[
				getMarkerPos _spawnPos, 
				_side, 
				(configFile >> "CfgGroups" >> (_sideArray select 0) >> (_sideArray select 1) >> (_grpType select 0) >> _type)
			] call BIS_fnc_spawnGroup;
		};
		case _moto: 
		{
			_grp = 
			[
			getMarkerPos _spawnPos, 
			_side, 
			(configFile >> "CfgGroups" >> (_sideArray select 0) >> (_sideArray select 1) >> (_grpType select 0) >> _type)
			] call BIS_fnc_spawnGroup;
		};
		case _tech: 
		{
			_grp = 
			[
				getMarkerPos _spawnPos,
				_side, 
				(configFile >> "CfgGroups" >> (_sideArray select 0) >> (_sideArray select 1) >> (_grpType select 1) >> _type)
			] call BIS_fnc_spawnGroup;
		};
	};
	
	[[[wave], {titleText [format["Enemy wave number %1 has spawned!", _this select 0], "PLAIN DOWN"]; playSound "waveSpawned";}], "bis_fnc_spawn"] call BIS_fnc_mp;
	
	_waypoint1 = _grp addWaypoint [getMarkerPos _attackMarker, 0];
	_waypoint1 setWayPointBehaviour "AWARE";
	_waypoint1 setWayPointSpeed "FULL";
	_waypoint1 setWayPointType "SAD";

	sleep _timer; 
};
