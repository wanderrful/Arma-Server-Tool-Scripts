///  Initialize the mission attributes
sv_playerSide = blufor;
sv_score = 1000;
sv_matchStarted = false;
sv_matchCompleted = false;
sv_currentTime = 0;



///  Verify that all necessary, editor-placed objects exist
if (isNil "trg_stagingArea") exitWith {
	"** ERROR: trg_stagingArea not found in the mission sqm file!" call BIS_fnc_error;
};



///  Define the special functions that will be used for this mission

// The proper way to modify the team's score for this mission.
sv_fnc_modifyScore = {
	// Arguments:  [int modifier, str reason]
	_modifier = param [0, 0];
	_reason = param [1, "ERROR: NO REASON GIVEN"];

	
	
	// Verify that the score variable exists
	if (isNil "sv_score") then {
		sv_score = 1000;
	};

	// Actually modify the score
	sv_score = sv_score + _modifier;

	// Let the players know!
	// sv_score: the new score
	// _modifier: the change inscore
	// _reason: the reason for the change
	[ "SXF_ScoreModified", [
		( [str _modifier, ""] select (_modifier isEqualTo 0) ), 
		_reason
	] ] remoteExec ["BIS_fnc_showNotification"]; //temporary
};
sv_fnc_beginMatch = {
	// Begin tracking the elapsed mission time
	call sv_fnc_initTimer;
	["SXF_MatchStarted"] remoteExec ["BIS_fnc_showNotification"];
};
sv_fnc_endMatch = {
	_success = param [0, false];

	sv_matchCompleted = true;
	["SXF_MatchFinished", [str sv_score]] remoteExec ["BIS_fnc_showNotification"];
	( ["EveryoneLost", "EveryoneWon"] select (_success) ) call BIS_fnc_endMissionServer;
};
sv_fnc_initTimer = {
	["itemAdd", ["MissionTimeLoop", {
		if (sv_matchCompleted) then {
			[ "ItemRemove", ["ScoreTimerLoop"] ] call BIS_fnc_loop;
			[ "ItemRemove", ["ElapsedMissionTimeLoop"] ] call BIS_fnc_loop;
		} else {
			if (isNil "sv_currentTime") then { sv_currentTime = 0; };
			
			sv_currentTime = sv_currentTime + 1;

			// -5 points for every elapsed minute in the mission
			if ( (sv_currentTime % 60) isEqualTo 0 ) then {
				[-5, "Time penalty"] call sv_fnc_modifyScore;
			};
		};
	}, 1, "seconds"] call BIS_fnc_loop;
};



///  Initialize the special event handlers for this mission

// React to an entity being killed
addMissionEventHandler["EntityKilled", {
	params ["_killed", "_killer", "_instigator", "_useEffects"];
	if (isPlayer _killed) then {
		[-50, "Player killed"] call sv_fnc_modifyScore;
	};
}];

// Begin the match when the first player leaves the staging area
["itemAdd", ["MatchStartLoop", {
	{
		scopeName "SXF_scope_playerLoop";
		if (side _x isEqualTo sv_playerSide) then {
			if ( !(_x inArea trg_stagingArea) ) then {
				call sv_fnc_beginMatch;
				[ "ItemRemove", ["MatchStartLoop"] ] call BIS_fnc_loop;
				breakOut "SXF_scope_playerLoop";
			};
		};
	} forEach (call BIS_fnc_listPlayers);
}, 1, "seconds"] call BIS_fnc_loop;