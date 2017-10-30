// The Mission Success scenario ending that I like to do

// Determine which kind of ending we want to do, exactly...
switch (_this) do {
	case "TeamWipedOut": {
		"MissionFail" remoteExec ["BIS_fnc_showNotification"];

		// Make sure that the special sound file exists
		if ( isClass (configFile >> "CfgSounds" >> "MissionFailureYourTeamWasWipedOut") ) then {
			"MissionFailureYourTeamWasWipedOut" remoteExec ["playSound"];
		};
		
		( parseText format["<br/><br/><t size='1.5' color='#E28014' align='center'>Mission Failure</t><br/>Your team was wiped out.<br/><br/><br/><br/>", nil] ) remoteExec ["hint"];
	};
	case "HostageKilled": {
		"MissionFailHostageKilled" remoteExec ["BIS_fnc_showNotification"];
		"MissionFailureAHostageWasKilled" remoteExec ["playSound"];
		( parseText format["<br/><br/><t size='1.5' color='#E28014' align='center'>Mission Failure</t><br/>A hostage was killed.<br/><br/><br/><br/>", nil] ) remoteExec ["hint"];
	};
};

"EveryoneLost" call BIS_fnc_endMissionServer;