//  GAMEPLAY FUNCTIONS
sv_fnc_beginCountdown = {
	for "_i" from 1 to 5 do {
		parseText format["<br/><br/><t align='left'>The match begins in:</t><br/><br/><t size='8'>%1</t><br/><br/><br/><br/>", str (6 - _i)] remoteExec ["hint"];
		sleep 1;
	};
	parseText "<br/><br/><br/><br/><t size='8'>GO!</t><br/><br/><br/><br/>" remoteExec ["hint"];
	
	//assign the start time for the race and propogate it to all players so they can check clientside
	sv_matchStartTime = diag_tickTime;
	
	call sv_fnc_startPlaying;
};



//  GAME STATE FUNCTIONS
sv_fnc_startPregame = {
	//hintSilent ""; to get rid of the hint message scoreboard
	hintSilent "";
	
	
	
	//teleport all non-spectators to their respective start locations
	
	
	
	//reset all tracked player stats
	{
		_x setVariable ["sxf_kills", 0, true];
	} forEach (call BIS_fnc_listPlayers);
	
	
	
	//begin the countdown to start the gameplay
	call sv_fnc_beginCountdown;

};
sv_fnc_startPlaying = {
	//begin tracking endgame conditions
	[ "itemAdd", [ 
		"checkEndgameConditions", {
			call sv_fnc_startPostgame;
			["itemRemove", ["checkEndgameConditions"]] call BIS_fnc_loop;
		}, 
		1, "seconds", { opfor countSide allUnits <= 0 || {blufor countSide allUnits <= 0} }
	] ] call BIS_fnc_loop; 
	
	
	
	//begin tracking each players' kills
	addMissionEventHandler [
		"EntityKilled",
		{
			params ["_killed", "_killer", "_instigator", "_useEffects"];
			if (isPlayer _instigator) then {
				_killCount = _instigator getVariable ["sxf_kills", -1];
				_instigator setVariable ["sxf_kills", (_killCount + 1), true];
			};
		}
	];
	
	
	
	//begin the hint message loop showing who is alive and who is dead, along with killcounts per player and # alive per team
};
sv_fnc_startPostgame = {
	//stop tracking endgame conditions
	
	//display which team won
	
	//stop the hint message loop so that it lingers, showing the final scoreboard information

};




//ENTRY FUNCTION
sv_fnc_main = {
	waitUntil {time>0};
	
	
	
	call sv_fnc_startPregame;
};



call sv_fnc_main;