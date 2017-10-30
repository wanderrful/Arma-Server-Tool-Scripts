//*** Initialize the countdown timer for all players



// Param 0:  the starting time on the clock
sv_currentTime = param [0, 0];

// Param 1: whether to end the mission and if so, do we win or lose?
sv_bWinOnTimerFinish = param [1, false];



[ "itemAdd", [ 
	"countdownTimer", {		
		sv_currentTime = sv_currentTime - 1;
		if (sv_currentTime isEqualTo 0) then {
			sv_currentTime = nil;

			if (!isNil "sv_bWinOnTimerFinish") then {
				( ["EveryoneLost", "EveryoneWon"] select sv_bWinOnTimerFinish ) call BIS_fnc_endMissionServer;
			};
		};
	}, 
	1, "seconds", {
		!isNil "sv_currentTime"
	}
] ] call BIS_fnc_loop; 