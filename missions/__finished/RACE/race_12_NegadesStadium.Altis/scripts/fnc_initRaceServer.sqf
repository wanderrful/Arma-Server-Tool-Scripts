//#SERVERSIDE

//initialize the attributes
sv_checkpoints = [trgcp_1, trgcp_2, trgcp_3, trgcp_4, trgcp_5, trgcp_6];
sv_raceInProgress = false; publicVariable "sv_raceInProgress";
sv_results = []; publicVariable "sv_results";


//FUNCTION DEFINITIONS
sxf_fnc_handlePlayerHasStartedRace = {}; //server-side version of the same function here in case I want the server to do anything different from the client
sxf_fnc_handlePlayerHasCompletedRaceServer = { //called by a player when they have finished the race
	sv_results pushBack _this; //add the player to the list of results
	publicVariable "sv_results";
	
	if (count sv_results isEqualTo (count call BIS_fnc_listPlayers)) then {
		sleep 3;
		[] spawn {
			//"Race has been completed!" remoteExec ["hint"];
			sv_raceInProgress = false;
			"Won" call BIS_fnc_endMissionServer;
		};
	};
};
sxf_fnc_countDownToStart = {
	[] spawn {
		_kartPrefix = "kart_";
		for "_i" from 1 to 99 do {
			scopeName "kartLoop";
			if ( isNil (_kartPrefix + str _i) ) then { breakOut "kartLoop"; } else {
				_temp = missionNamespace getVariable [(_kartPrefix + str _i), objNull];
				_temp allowDamage false; //hope this fixes the issue
				if (!isNil (_kartPrefix + str _i) && { ( driver _temp ) isEqualTo objNull } ) then { deleteVehicle _temp; };
			};
		};
		for "_i" from 1 to 5 do {
			parseText format["<br/><br/><t align='left'>The race begins in:</t><br/><br/><t size='8'>%1</t><br/><br/><br/><br/>", str (6 - _i)] remoteExec ["hint"];
			sleep 1;
		};
		parseText "<br/><br/><br/><br/><t size='8'>GO!</t><br/><br/><br/><br/>" remoteExec ["hint"];
		{ 
			if (side player isEqualTo civilian) then { 
				call sxf_fnc_handlePlayerHasStartedRace; 
				(vehicle player) setFuel 1; 
				player setVariable ["sxf_raceStartTime", diag_tickTime, true];
			}; 
		} remoteExec ["bis_fnc_call"];
		sv_raceInProgress = true; publicVariable "sv_raceInProgress";

	};
};



//start the race
[] spawn { 
	sleep 10;
	call sxf_fnc_countDownToStart;
};