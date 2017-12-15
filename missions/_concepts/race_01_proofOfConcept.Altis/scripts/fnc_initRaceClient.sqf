//#CLIENTSIDE
player allowDamage false; //kart is already set to invulnerable via mission.sqm



//initialize the attributes
cl_checkpoints = [trgcp_1, trgcp_2, trgcp_3, trgcp_4];
cl_checkpointArrow = objNull;
cl_checkpointSound = "FD_Start_F";
cl_directionalArrow = objNull;

_kart = ( missionNamespace getVariable "kart_" +  ( ( (vehicleVarName player) splitString "_" ) select 1 ) );
player setVariable ["sxf_assignedKart", _kart];



//** FUNCTION DEFINITIONS:
	//* debug functions
sxf_fnc_debug = { playSound "FD_Start_F"; hint "** sxf_fnc_debug entry:"; };

	//* event functions
sxf_fnc_moveInDriver = {
	player moveInDriver (player getVariable ["sxf_assignedKart", objNull]);
};
sxf_fnc_onEachFrame = {
	if ( player inArea (player getVariable ["sxf_nextCheckpoint", objNull]) ) then {
		call sxf_fnc_handleReachedCheckpoint;
	};
	cl_directionalArrow setPos [
		(position player select 0) + (2 * sin (getDirVisual player)),
		(position player select 1) + (2 * cos (getDirVisual player)),
		0.25
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
	
	if (count cl_checkpoints <= 0) exitWith { call sxf_fnc_handlePlayerHasCompletedRace; };
	
	//* move the pink arrow checkpoint indicator
	if (cl_checkpointArrow isEqualTo objNull) then {
		cl_checkpointArrow = "Sign_Arrow_Large_Pink_F" createVehicleLocal [0,0,0];
	};
	cl_checkpointArrow setPos [
			position (cl_checkpoints select 0) select 0,
			position (cl_checkpoints select 0) select 1,
			1.25
	];
	//* assign the directional arrow
	if (cl_directionalArrow isEqualTo objNull) then {
		cl_directionalArrow = "Sign_Arrow_Direction_Pink_F" createVehicleLocal [0,0,0];
	};
	
	player setVariable ["sxf_nextCheckpoint", cl_checkpoints select 0];
	addMissionEventHandler ["EachFrame",sxf_fnc_onEachFrame];
};
sxf_fnc_handleReachedCheckpoint = {
	["TaskSucceeded", ["", "Checkpoint reached!"]] call BIS_fnc_showNotification;
	cutRsc ["IconImage","PLAIN"];
	call sxf_fnc_assignNextCheckpoint;
};

	//handle primary mission events
sxf_fnc_handlePlayerHasStartedRace = {
	["TimeTrialStarted", ["penis"]] call BIS_fnc_showNotification;
	//{ _x call sxf_fnc_resetCheckpointHandler; } forEach cl_checkpoints;
	call sxf_fnc_assignNextCheckpoint;
};
sxf_fnc_handlePlayerHasCompletedRace = {
	if (! (cl_checkpointArrow isEqualTo objNull) ) then { deleteVehicle cl_checkpointArrow; };
	if (! (cl_directionalArrow isEqualTo objNull) ) then { deleteVehicle cl_directionalArrow; };
	["TimeTrialEnded", ["penis"]] call BIS_fnc_showNotification;
};

	//* UI management functions
sxf_fnc_setRaceInfoPanelText = {	//TODO: make the info panel text box change its contents to list the players
	_text = _this;
	_ctrl = (uiNamespace getVariable "RaceInfoPanel") displayCtrl 28211;
	ctrlSetText [_ctrl, _text];
};



//move player back into her kart when she gets out
(player getVariable ["sxf_assignedKart", objNull]) addEventHandler ["GetOut", sxf_fnc_moveInDriver];

//start the race
call sxf_fnc_handlePlayerHasStartedRace;

//spawn the race info panel widget
("Race_Info_Panel" call BIS_fnc_rscLayer) cutRsc ["RaceInfoPanel", "PLAIN"];

//move the player into the kart, initially
call sxf_fnc_moveInDriver;