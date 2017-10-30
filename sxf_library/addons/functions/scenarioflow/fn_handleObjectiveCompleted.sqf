// The Objective Completed thing that I like to do


if ( isClass (configFile >> "CfgNotifications" >> "ObjectiveCompleted") ) then {
	"ObjectiveCompleted" remoteExec ["BIS_fnc_showNotification"];
};

// Make sure that the special sound file that I like to use actually exists in the mission
if ( isClass (configFile >> "CfgSounds" >> "MissionSuccessObjectiveCompleted") ) then {
	"MissionSuccessObjectiveCompleted" remoteExec ["playSound"];
};