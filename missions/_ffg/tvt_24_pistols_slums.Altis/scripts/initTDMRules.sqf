//#SERVERSIDE



sv_teamList = [blufor, opfor, independent, civilian];
sv_playerTeamList = [ [], [], [], [] ];



//*** Define the primary means of checking whether a team has met its win condition (i.e. all other teams are dead or incapacitated)
sxf_TDM_bTeamDead = {
	/*		Returns whether all players for the given side are dead
	 *
	 *		syntax:   array call sxf_TDM_bTeamDead;
	 *		returns:  boolean
	 * 
	 * 		example:  [blufor, opfor, independent] call sxf_TDM_bTeamDead;
	 *
	 */
	_result = true;
	{
		scopeName "forEachSide";
		
		_result = (
			_result 
			&& {  { lifeState _x in ["HEALTHY", "INJURED"] } count sv_playerTeamList select (sv_teamList find _x) isEqualTo 0  }
		);
		
		if (!_result) then { breakOut "forEachSide"; };
	} forEach _this;


	
	_result
};
sxf_TDM_checkWinCondition = {
	//*** Returns whether the given side's win condition (i.e. all other team's players are dead) has been met
	_result = (sv_teamList - [_this]) call sxf_TDM_bTeamDead;
	
	
	
	_result
};



//*** Begin the looping win condition checks for whatever sides are currently in play
if ( !(blufor countSide allUnits isEqualTo 0) ) then {
	[ "itemAdd", [ 
		"checkBluforWins", {
			blufor call sxf_TDM_handleGameOver;
			["itemRemove", ["checkBluforWins"]] call BIS_TDM_loop;
		}, 
		1, "seconds", { blufor call sxf_TDM_checkWinCondition }
	] ] call BIS_TDM_loop; 
};
if ( !(opfor countSide allUnits isEqualTo 0) ) then {
	[ "itemAdd", [ 
		"checkOpforWins", {
			opfor call sxf_TDM_handleGameOver;
			["itemRemove", ["checkOpforWins"]] call BIS_TDM_loop;
		}, 
		1, "seconds", { opfor call sxf_TDM_checkWinCondition }
	] ] call BIS_TDM_loop; 
};
if ( !(independent countSide allUnits isEqualTo 0) ) then {
	[ "itemAdd", [ 
		"checkIndependentWins", {
			independent call sxf_TDM_handleGameOver;
			["itemRemove", ["checkIndependentWins"]] call BIS_TDM_loop;
		}, 
		1, "seconds", { independent call sxf_TDM_checkWinCondition }
	] ] call BIS_TDM_loop; 
};
if ( !(civilian countSide allUnits isEqualTo 0) ) then {
	[ "itemAdd", [ 
		"checkCivilianWins", {
			civilian call sxf_TDM_handleGameOver;
			["itemRemove", ["checkCivilianWins"]] call BIS_TDM_loop;
		}, 
		1, "seconds", { civilian call sxf_TDM_checkWinCondition }
	] ] call BIS_TDM_loop; 
};



//*** Handle the win/fail conditions for all teams
sxf_TDM_handleGameOver = {
	//*** _this must be the winning side of the match!
	_this call sxf_TDM_handleTeamWins;
	(sv_teamList - [_this]) call sxf_TDM_handleTeamLoses;
	"SideScore" call BIS_TDM_endMissionServer;
};
sxf_TDM_handleTeamWins = {
	//_this must be a team (e.g. blufor, opfor, independent, civilian)
	"MissionSuccess" remoteExec ["BIS_TDM_showNotification", _this];
	"MissionSuccessObjectiveCompleted" remoteExec ["playSound", _this];
	( parseText format["<br/><br/><t size='1.5' color='#E28014' align='center'>Mission Success</t><br/>Objective Completed<br/><br/><br/><br/>", nil] ) remoteExec ["hint", _this];
};
sxf_TDM_handleTeamLoses = {
	//_this must be a team (e.g. blufor, opfor, independent, civilian)
	"MissionFail" remoteExec ["BIS_TDM_showNotification", _this];
	"MissionFailureYourTeamWasWipedOut" remoteExec ["playSound", _this];
	( parseText format["<br/><br/><t size='1.5' color='#E28014' align='center'>Mission Failure</t><br/>Your team was wiped out.<br/><br/><br/><br/>", nil] ) remoteExec ["hint", _this];
};



//*** Handle when a player has loaded into the mission.  CALL THIS FROM INITPLAYERSERVER.SQF!
sxf_TDM_handlePlayerEntry = {
	//*** If the player has joined after the briefing has ended, they need to go straight to spectator!
	if (time > 0) exitWith {
		_this setDamage 1;
		deleteVehicle _this;
	};
	
	//*** Add this player to the server's list of player sides so that the hint message works properly!
	if (  !( (str side _this) isEqualTo "LOGIC" )  ) then {
		waitUntil {!isNil "sv_playerTeamList"};
		sv_playerTeamList select ( find (side _this) ) pushBack _this;
	};	
};