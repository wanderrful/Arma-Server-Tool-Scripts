//#CLIENTSIDE
if (! (side player isEqualTo civilian) ) exitWith {};
player allowDamage false;



//initialize the attributes
cl_checkpoints = [];
cl_finishTime = -1;
_triggerPrefix = "trgcp_";
for "_i" from 1 to 99 do {
	scopeName "triggerLoop";
	if ( isNil (_triggerPrefix + str _i) ) then { breakOut "triggerLoop"; } else {
		cl_checkpoints pushBack ( missionNamespace getVariable [(_triggerPrefix + str _i), objNull] );
	};
};
cl_checkpointArrow = objNull;
cl_directionalArrow = objNull;
cl_checkpointSound = "FD_Start_F";

_kart = ( missionNamespace getVariable "kart_" +  ( ( (vehicleVarName player) splitString "_" ) select 1 ) );
player setVariable ["sxf_assignedKart", _kart];



//** FUNCTION DEFINITIONS:
	//* debug functions
sxf_fnc_debug = { playSound "FD_Start_F"; hint "** sxf_fnc_debug called"; };



	//* event functions
sxf_fnc_moveInDriver = {
	player moveInDriver (player getVariable ["sxf_assignedKart", objNull]);
	(vehicle player) allowDamage false;
	if (!isNil "sv_raceInProgress") then {
		if (sv_raceInProgress) then { (vehicle player) setFuel 1; };
	};
};
sxf_fnc_onEachFrame = {
	if ( player inArea (player getVariable ["sxf_nextCheckpoint", objNull]) ) then {
		call sxf_fnc_handleReachedCheckpoint;
	};
	cl_directionalArrow setPosASL [
		(getPosASL player select 0) + (1.5 * sin (getDirVisual player)),
		(getPosASL player select 1) + (1.5 * cos (getDirVisual player)),
		(getPosASL player select 2) + 0.2
	];
	cl_directionalArrow setDir (player getDir cl_checkpointArrow);
};



	//* checkpoint functions
sxf_fnc_resetCheckpointHandler = { removeAllMissionEventHandlers "EachFrame"; };
sxf_fnc_assignNextCheckpoint = {
	_currentCheckpoint = player getVariable ["sxf_nextCheckpoint", objNull];
	cl_checkpoints = cl_checkPoints - [_currentCheckpoint];	
	_currentCheckpoint call sxf_fnc_resetCheckpointHandler;
	
	playSound cl_checkpointSound;
	
	if (count cl_checkpoints <= 0) exitWith { 
		//instead of just "player", send the server an array containing the player and their finishing time
		[ player , { _this call sxf_fnc_handlePlayerHasCompletedRaceServer; } ] remoteExec ["bis_fnc_call", 2];
		call sxf_fnc_handlePlayerHasCompletedRace;
		[] spawn {
			sleep 2;
			(vehicle player) setPos (position teleportHereAfterFinishing); //it's a game logic that was placed in the editor
		};
	};
	
	//* move the pink arrow checkpoint indicator
	if (cl_checkpointArrow isEqualTo objNull) then {
		cl_checkpointArrow = "Sign_Arrow_Large_Pink_F" createVehicleLocal [0,0,0];
	};
	cl_checkpointArrow setPosASL [
			getPosASL (cl_checkpoints select 0) select 0,
			getPosASL (cl_checkpoints select 0) select 1,
			(getPosASL (cl_checkpoints select 0) select 2) + 1.25
	];
	cl_checkpointArrow setVectorUp [0,0,1];
	//* assign the directional arrow
	if (cl_directionalArrow isEqualTo objNull) then {
		cl_directionalArrow = "Sign_Arrow_Direction_Pink_F" createVehicleLocal [0,0,0];
	};
	
	player setVariable ["sxf_nextCheckpoint", cl_checkpoints select 0];
	addMissionEventHandler ["EachFrame",sxf_fnc_onEachFrame];
};
sxf_fnc_handleReachedCheckpoint = {
	if (count cl_checkpoints > 1) then { ["TaskSucceeded", ["", "Checkpoint reached!"]] call BIS_fnc_showNotification; };
	cutRsc ["IconImage","PLAIN"];
	call sxf_fnc_assignNextCheckpoint;
};



	//handle primary mission events
sxf_fnc_handlePlayerHasStartedRace = {
	["RaceStart"] call BIS_fnc_showNotification;
	//{ _x call sxf_fnc_resetCheckpointHandler; } forEach cl_checkpoints;
	call sxf_fnc_assignNextCheckpoint;
	[] spawn {	//begin the hint message loop after 60 seconds
		[ "itemAdd", ["loopMessage", { hint call sxf_fnc_getResultsData; }, 0.5] ] call BIS_fnc_loop; 
	};
};
sxf_fnc_handlePlayerHasCompletedRace = {
	if (count cl_checkpoints > 0) exitWith {}; //this player has not actually completed the race yet so nevermind
	if (! (cl_checkpointArrow isEqualTo objNull) ) then { deleteVehicle cl_checkpointArrow; };
	if (! (cl_directionalArrow isEqualTo objNull) ) then { deleteVehicle cl_directionalArrow; };
	cl_finishTime =  diag_tickTime - (player getVariable ["sxf_raceStartTime", 9999]);
	player setVariable ["sxf_raceFinishTime", cl_finishTime, true];
	["RaceEnd"] call BIS_fnc_showNotification;
	[
		[player, cl_finishTime],
		{ 
			_this call sxf_fnc_handlePlayerHasCompletedRaceServer;
		} 
	] remoteExec ["bis_fnc_call", 2];
};


	//* UI management functions
sxf_fnc_setRaceInfoPanelText = {	//TODO: make the info panel text box change its contents to list the players
	_text = _this;
	_ctrl = (uiNamespace getVariable "RaceInfoPanel") displayCtrl 28211;
	ctrlSetText [_ctrl, _text];
};
sxf_fnc_getResultsData = {
	_output = "";
	{
		if (side _x isEqualTo civilian) then {
			_currentTime =  diag_tickTime - (_x getVariable ["sxf_raceStartTime", 9999]);
			_finishTime = _x getVariable ["sxf_raceFinishTime", -1];
			if (_finishTime != -1) then { _currentTime = "** " + str _finishTime + " **"; };
			_textColor = "";
			if ( !(isNil "sv_results") && {_x in sv_results} ) then { _textColor = "color='#E28014'" };
			_output = _output + format [
				"<t align='left' %3>     %1</t><t align='right' %3>%2 sec    </t><br/>",
				name _x, 
				_currentTime,
				_textColor
			];
		};
	} forEach call BIS_fnc_listPlayers;
	
	parseText format [
		(
			(
				"<t size='1.5' color='#E28014' align='center'>Race: Negades Stadium</t><br/>by sixtyfour"
			) + (
				"<br/><br/>"
			) + (
				"<t align='left'>Player name:</t><t align='right'>Time</t><br/>--------------------------<br/>"
			) + (
				"%1"	//results table
			) + (
				"--------------------------<br/>"
			) + (
				"<br/><br/>"
			) + (
				""
			)
		),
		_output
	];
};



//move player back into her kart when she gets out
(player getVariable ["sxf_assignedKart", objNull]) addEventHandler ["GetOut", sxf_fnc_moveInDriver];

//spawn the race info panel widget
("Race_Info_Panel" call BIS_fnc_rscLayer) cutRsc ["RaceInfoPanel", "PLAIN"];

//move the player into the kart, initially
call sxf_fnc_moveInDriver;