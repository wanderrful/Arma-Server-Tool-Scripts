/*	relevant object vehicle names
	p_cmd_officer, p_cmd_radio
	p_gun_1, p_gun_2 (gunship1, gunship2)
	p_trans_1, p_trans_2 (transport1, transport2)
	p_t1_leader, p_t1_radio, p_t1_medic, p_t1_gun_1, p_t1_gun_2, p_t1_rifle
	p_t2_leader, p_t2_radio, p_t2_medic, p_t2_gun_1, p_t2_gun_2, p_t2_rifle
*/



//VARIABLE DECLARATIONS
enableSaving [false, false];
enableSentences false;

sv_missionComplete 	= false; publicVariable "sv_missionComplete";
sv_missionFailed 		= false; publicVariable "sv_missionFailed";
sv_hostageKilled 		= false; publicVariable "sv_hostageKilled";

sv_cmd				= [];
sv_team1 			= [];
sv_team2 			= [];
sv_trans 			= [];
sv_gun 				= [];

sv_transHelos			= [transport1, transport2];
sv_gunships			= [gunship1, gunship2];

sv_hostageGroup 		= createGroup civilian;
sv_hostageList 		= [hostage1, hostage2, hostage3]; publicVariable "sv_hostageList";
sv_hostageCount 		= count sv_hostageList;
sv_extractionStatus 	= [];
sv_extractedHostages 	= [];
sv_extractionZones	= [trg_extractionZone1, trg_extractionZone2];

sv_teamDetected		= false; publicVariable "sv_teamDetected";

sv_supplybox_medical	= [supplybox_medical_1, supplybox_medical_2, supplybox_medical_3, supplybox_medical_4];
sv_supplybox_ammo		= [supplybox_ammo_1, supplybox_ammo_2, supplybox_ammo_3, supplybox_ammo_4];


sxf_fnc_setHostageExtracted = 
{	//this function requires a single hostage unit reference (ex: hostage1 call sxf_fnc_setHostageExtracted)
	_temp = sv_hostageList find _this;
	if (_temp != -1) then
	{
		if ( !(sv_extractionStatus select _temp) ) then
		{
			sv_extractionStatus set [_temp, true];
			sv_extractedHostages pushBack _this;
		};
	} 
	else
	{
		diag_log "ERROR: sxf_fnc_setHostageExtracted INVALID ARGUMENT (initHostageScenario.sqf)";
	};
};



//INITIALIZE THE ATTRIBUTES
{
	if (!isNil _x) then { sv_cmd pushBack (missionNamespace getVariable _x) }; 
} forEach ["p_cmd_officer", "p_cmd_radio"];
{
	if (!isNil _x) then { sv_team1 pushBack (missionNamespace getVariable _x) }; 
} forEach ["p_t1_leader", "p_t1_radio", "p_t1_medic", "p_t1_gun_1", "p_t1_gun_2", "p_t1_rifle"];
{
	if (!isNil _x) then { sv_team2 pushBack (missionNamespace getVariable _x) }; 
} forEach ["p_t2_leader", "p_t2_radio", "p_t2_medic", "p_t2_gun_1", "p_t2_gun_2", "p_t2_rifle"];
{
	if (!isNil _x) then { sv_trans pushBack (missionNamespace getVariable _x) }; 
} forEach ["p_trans_1", "p_trans_2"];
{
	if (!isNil _x) then { sv_gun pushBack (missionNamespace getVariable _x) }; 
} forEach ["p_gun_1", "p_gun_2"];

{
	sv_extractionStatus pushBack false;	
	[_x] joinSilent sv_hostageGroup;
	_x switchMove "Acts_AidlPsitMstpSsurWnonDnon01";	//initial animation: sitting down and tied up
	_x disableAI "AUTOCOMBAT";
	_x disableAI "FSM";
	_x disableAI "CHECKVISIBLE";
	_x disableAI "TARGET";
	_x disableAI "PATH";
	_x disableAI "MOVE";
	_x addEventHandler
	[
		"Killed",
		{ sv_hostageKilled = true; publicVariable "sv_hostageKilled";}
	];
	[_x, true, 3600, true] call ACE_Medical_fnc_setUnconscious;
} forEach sv_hostageList;
{
	if (side _x == independent) then {
		_x addEventHandler
		[	//when this event fires, it means that players have been detected by the enemy
			"Fired",
			{
				sv_teamDetected = true; publicVariable "sv_teamDetected";
				[] spawn {
					sleep 5;
					"Your team has been detected by the Guerillas!  Reinforcements have been called." remoteExec ["hint"];
				};
			}
		];
	};
} forEach allUnits;
{
	[_x, 0] execVM "scripts\fnc_rearmHelicopter.sqf";
	[_x, 0] execVM "scripts\fnc_repairHelicopter.sqf";
} forEach sv_gunships;
{
	_x setTriggerActivation ["CIV", "PRESENT", true];
	_x setTriggerStatements
	[
		"this && {!(_x in sv_extractedHostages)} count thisList > 0",
		"if (isServer) then { {_x call sxf_fnc_setHostageExtracted;} forEach thisList; }; ['TaskSucceeded', ['', 'A hostage has been extracted!']] call BIS_fnc_showNotification;",
		""
	];
} forEach sv_extractionZones;
{
	_x addItemCargoGlobal ["30Rnd_556x45_Stanag", 24];
	_x addItemCargoGlobal ["SmokeShell", 6];
} forEach sv_supplybox_ammo;
{
	_x addItemCargoGlobal ["ACE_fieldDressing",24]; //basic ace medical equipment
	_x addItemCargoGlobal ["ACE_epinephrine",8];
	_x addItemCargoGlobal ["ACE_morphine",12];
	_x addItemCargoGlobal ["ACE_bloodIV_500",9];
} forEach sv_supplybox_medical;



//TRIGGER DECLARATIONS
_trg = createTrigger ["EmptyDetector", [0,0,0], false];	//delete special stealth event handlers when players are detected
_trg setTriggerActivation ["NONE", "PRESENT", true];
_trg setTriggerStatements 
[
	"sv_teamDetected",
	"{ if (side _x == indepdendent) then { _x removeAllEventHandlers 'FiredMan'; }; } forEach allUnits; ",
	""
];
_trg = createTrigger ["EmptyDetector", [0,0,0], true];	//handle mission success
_trg setTriggerActivation ["NONE", "PRESENT", true];
_trg setTriggerStatements 
[
	"count sv_extractedHostages >= count units sv_hostageGroup",
	"missionComplete = true; publicVariable 'missionComplete'; if (isServer) then {'Won' call BIS_fnc_endMissionServer;}; playSound 'MissionSuccessObjectiveCompleted';",
	""
];
_trg = createTrigger ["EmptyDetector", [0,0,0], false];	//handle mission failure (teams one and two are dead)
_trg setTriggerActivation ["NONE", "PRESENT", true];
_trg setTriggerStatements 
[
	"{alive _x} count sv_team1 <= 0 && { {alive _x} count sv_team2 <= 0 && { count (call BIS_fnc_listPlayers) > 1  } }",
	"if (isServer) then {'Lost' call BIS_fnc_endMissionServer;}; playSound 'MissionFailureYourTeamWasWipedOut';",
	""
];
_trg = createTrigger ["EmptyDetector", [0,0,0], true];	//handle mission failure (hostage killed)
_trg setTriggerActivation ["NONE", "PRESENT", true];
_trg setTriggerStatements 
[
	"sv_hostageKilled",
	"if (isServer) then {'Lost' call BIS_fnc_endMissionServer;}; playSound 'MissionFailureAHostageWasKilled';",
	""
];

waitUntil {time>0};

deleteMarker "briefing-marker_1"; //the lazy way
deleteMarker "briefing-marker_2";
deleteMarker "briefing-marker_3";
deleteMarker "briefing-marker_4";
deleteMarker "briefing-marker_5";