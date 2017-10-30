// The Mission Success scenario ending that I like to do



"MissionSuccess" remoteExec ["BIS_fnc_showNotification"];

// Make sure that the special sound file that I like to use actually exists in the mission
if ( isClass (configFile >> "CfgSounds" >> "MissionSuccessObjectiveCompleted") ) then {
	"MissionSuccessObjectiveCompleted" remoteExec ["playSound"];
};

"EveryoneWon" call BIS_fnc_endMissionServer;

( parseText format ["<br/><br/><t size='1.5' color='#E28014' align='center'>Mission Success</t><br/>Objective Completed<br/><br/><br/><br/>", nil] ) remoteExec ["hint"];