private ["_origin"];

_origin = [0,0,0];

wave = 0; //used for scripts\holdout.sqf to keep consistent wave #s during the recursions

started = false;
publicVariable "started";

arsenalBox allowDamage false;

//create the necessary markers we'll set their properties as they get placed on the map later on)
baseMarker			= createMarker ["town", getMarkerPos "respawn_west"];
spawnMarker1			= createMarker ["spawn_north", _origin];
spawnMarker2			= createMarker ["spawn_south", _origin];
spawnMarker3			= createMarker ["spawn_east", _origin];
spawnMarker4			= createMarker ["spawn_west", _origin];

trg_initHoldout		= createTrigger ["EmptyDetector", _origin]; //server-only
trg_loopTrigger_1		= createTrigger ["EmptyDetector", _origin]; //server-only
trg_loopTrigger_2		= createTrigger ["EmptyDetector", _origin]; //server-only
trg_loopTrigger_p1	= createTrigger ["EmptyDetector", _origin]; //client-only
trg_loopTrigger_p2	= createTrigger ["EmptyDetector", _origin]; //client-only

publicVariable "trg_loopTrigger_p1";
publicVariable "trg_loopTrigger_p2";

reminderLoop			= nil;

_cond = "started";
_onAct = "
reminderLoop = true;
arsenalBox2 setPos (getMarkerPos 'town');
[
	{
		playSound 'introSound'; 
		preloadCamera getMarkerPos 'town'; 
		player setPos getMarkerPos 'town'; 
		sleep 15; 
		reminderLoop2 = true;
		hintSilent '';
	},
	'bis_fnc_spawn'
] call BIS_fnc_mp;
 ";
_onDeact = "";
trg_initHoldout setTriggerActivation ["NONE", "NOT PRESENT", false];
trg_initHoldout setTriggerStatements [_cond, _onAct, _onDeact];

_cond = "reminderLoop";
_onAct = "[120,0,10,'spawn_north','spawn_east','spawn_west','spawn_south','town'] execVM 'scripts\holdout.sqf'; reminderLoop = false;";
_onDeact = "";
trg_loopTrigger_1 setTriggerActivation ["NONE", "NOT PRESENT", true];
trg_loopTrigger_1 setTriggerStatements [_cond, _onAct, _onDeact];
trg_loopTrigger_1 setTriggerTimeout [0,0,0,false];

_cond = "!reminderLoop";
_onAct = "reminderLoop = true;";
_onDeact = "";
trg_loopTrigger_2 setTriggerActivation ["NONE", "NOT PRESENT", true];
trg_loopTrigger_2 setTriggerStatements [_cond, _onAct, _onDeact];
trg_loopTrigger_2 setTriggerTimeout [900,900,900,false];

waitUntil {time > 0};