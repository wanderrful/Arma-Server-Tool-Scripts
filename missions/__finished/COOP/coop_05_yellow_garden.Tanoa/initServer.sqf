sv_initServerCompleted = false;

enableSentences false;
enableSaving [false, false];

execVM "scripts\initHostageScenario.sqf";
execVM "scripts\initLoadouts.sqf";

sv_initServerCompleted = true;