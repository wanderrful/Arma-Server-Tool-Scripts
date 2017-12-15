//Made by sixtyfour, 19 July 2016
//-------------------------------

//you can configure these two local variables below based on your mission:
_tempHostageList = ["hostage1", "hostage2", "hostage3"];
_tempExtractionZones = ["trg_extractionZone1", "trg_extractionZone2", "trg_extractionZone3"];



//#SERVERSIDE
sv_missionComplete = false; publicVariable "sv_missionComplete";	//will automatically set to true when all hostages are extracted
sv_missionFailed = false; publicVariable "sv_missionFailed";		//will automatically set to true when a hostage is killed

sv_hostageGroup = createGroup civilian;
sv_hostageList = []; publicVariable "sv_hostageList";
sv_extractionStatus = [];
sv_extractedHostages = [];

sv_extractionZones = [];

{	//check whether the given hostage units actually exist
	if (!isNil _x) then { sv_hostageList pushBack (missionNamespace getVariable _x); };
} forEach _tempHostageList;
publicVariable "sv_hostageList";
if (count sv_hostageList <= 0) exitWith 
{
	diag_log "ERROR: NO HOSTAGES FOUND IN THIS MISSION! (initHostageScenario.sqf)";
};
{	//now that we have the hostage list, let's assign the initial attributes for each one
	sv_extractionStatus pushBack false;	
	[_x] joinSilent sv_hostageGroup;
	_x setVariable ["bCarried", false, true];
	_x switchMove "Acts_AidlPsitMstpSsurWnonDnon01";	//initial animation: sitting down and tied up
	_x disableAI "AUTOCOMBAT";
	_x disableAI "FSM";
	_x disableAI "CHECKVISIBLE";
	_x disableAI "TARGET";
	_x disableAI "PATH";
	_x disableAI "MOVE";

	_trg = createTrigger ["EmptyDetector", [0,0,0], false];	//death -> mission failure
	_trg setTriggerActivation ["NONE", "PRESENT", true];
	_trg setTriggerStatements 
	[
		"!alive " + vehicleVarName _x, 
		"sv_missionFailed = true; publicVariable 'sv_missionFailed';",
		""
	];
} forEach sv_hostageList;

{	//check whether "trg_extractionZone1", "trg_extractionZone2", or "trg_extractionZone3" exist
	if (!isNil _x) then { sv_extractionZones pushBack (missionNamespace getVariable _x); };
} forEach _tempExtractionZones;
if (count sv_extractionZones <= 0) exitWith 
{
	diag_log "ERROR: NO EXTRACTION ZONES FOUND IN THIS MISSION! (initHostageScenario.sqf)";
};
{
	_x setTriggerActivation ["CIV", "PRESENT", true];
	_x setTriggerStatements
	[
		"this && {!(_x in sv_extractedHostages)} count thisList > 0",
		"{_x call sxf_fnc_setHostageExtracted;} forEach thisList;",
		""
	];
} forEach sv_extractionZones;

_trg = createTrigger ["EmptyDetector", [0,0,0], true];	//victory trigger
_trg setTriggerActivation ["NONE", "PRESENT", false];
_trg setTriggerStatements 
[
	"{_x} count sv_extractionStatus == count sv_hostageList",
	"sv_missionComplete = true;",
	""
];



{	//#CLIENTSIDE (initialization for each player)
	if (hasInterface) then 
	{
		{
			player setVariable 
			[
				("carryAction_" + vehicleVarName _x), 
				_x addAction
				[
					"Carry the hostage",
					{
						params ["_theHostage", "_thePlayer", "_actionID", "_args"];
						
						_bCarried = _theHostage getVariable "bCarried";
						if (_bCarried) then 
						{	//drop the hostage		
							_thePlayer disableCollisionWith _theHostage;
							_thePlayer switchMove "";
							_theHostage playMove "Acts_PercMstpSlowWrflDnon_handup2";
							sleep 0.1;
							_theHostage switchMove "Acts_AidlPsitMstpSsurWnonDnon01";
							detach _theHostage;
							_thePlayer enableCollisionWith _theHostage;
						
							_theHostage setUserActionText [_actionID, "Carry the hostage"];
							_theHostage setVariable ["bCarried", !_bCarried, true];
						}
						else 
						{	//make sure the player can only carry one hostage at a time
							if (count attachedObjects _thePlayer <= 0) then
							{	//carry the hostage
								_position = [0,-.1,-1.2];
								_direction = (getDir _thePlayer) + 180;

								_thePlayer switchMove "AcinPercMstpSnonWnonDnon";
								_theHostage playMove "AinjPfalMstpSnonWnonDf_carried_dead";
								sleep 0.1;
								_theHostage switchMove "AinjPfalMstpSnonWnonDf_carried_dead";
								_theHostage attachTo [_thePlayer, _position, "LeftShoulder"];
							
								_theHostage setUserActionText [_actionID, "Drop the hostage"];
								_theHostage setVariable ["bCarried", !_bCarried, true];
							};
						};
					},
					[],
					6,
					true,
					true,
					"",
					"(count attachedObjects _this <= 0)  || { (count attachedObjects _this) > 0 && {_target in (attachedObjects _this)} }",
					2.75,
					false
				]
			];
		} forEach sv_hostageList;
	};
} remoteExecCall ["bis_fnc_call"];



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



//end of file
diag_log "initHostageScenario.sqf loaded successfully!";