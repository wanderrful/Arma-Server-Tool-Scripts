_unit		= _this select 0;
_didJIP		= _this select 1;

//tagus_fnc_whiteListTheArsenal = compileFinal preprocessFile "scripts\tagus\fnc_whiteListTheArsenal.sqf";

reminderLoop2 = nil;

waitUntil {time > 0};

{
	["AmmoboxInit", [_x, true, {true}]] spawn BIS_fnc_arsenal;
} forEach [arsenalBox, arsenalBox2];

if (!started) then {
	whiteboardAction = whiteBoard addAction ["<t color='#66DD99'>Mission Setup</t>","scripts\setup\setup.sqf"];
} else
{
	whiteboardAction = whiteBoard addAction ["<t color='#dddd22'>Teleport to the AO!</t>", {preloadCamera getMarkerPos 'town'; player setPos getMarkerPos 'town';}];
};
_unit addMPEventHandler 
[
	"MPRespawn",
	{
		systemChat "Get back into the fight by using the Teleport action at the whiteboard!";
		player setDir -20;
	}
];

_cond = "reminderLoop2";
_onAct = "
hint parseText format
[
""
	<t align='left'>Enemies within 500m~1km:</t> <t color='#6699CC' size='1.25' align='right'>%1</t>
	<br />
	<t align='left'>Enemies within 250m~500m:</t> <t color='#6699CC' size='1.25' align='right'>%2</t>
	<br />
	<t align='left'>Enemies within 250m:</t> <t color='#6699CC' size='1.25' align='right'>%3</t>
"",
{side _x == opfor && {player distance _x <= 1000} && {player distance _x > 500}} count allUnits, 
{side _x == opfor && {player distance _x <= 500} && {player distance _x > 250}} count allUnits, 
{side _x == opfor && {player distance _x <= 250}} count allUnits]; 
reminderLoop2 = false;
";
_onDeact = "";
trg_loopTrigger_p1 setTriggerActivation ["NONE", "NOT PRESENT", true];
trg_loopTrigger_p1 setTriggerStatements [_cond, _onAct, _onDeact];
trg_loopTrigger_p1 setTriggerTimeout [13,13,13,false];

_cond = "!reminderLoop2";
_onAct = "hintSilent ''; reminderLoop2 = true;";
_onDeact = "";
trg_loopTrigger_p2 setTriggerActivation ["NONE", "NOT PRESENT", true];
trg_loopTrigger_p2 setTriggerStatements [_cond, _onAct, _onDeact];
trg_loopTrigger_p2 setTriggerTimeout [7,7,7,false];

titleText ["", "PLAIN"];

_script = ["Open", true] spawn BIS_fnc_arsenal;
waitUntil {scriptDone _script};
//_actionArsenal = _unit getVariable ["bis_fnc_arsenal_action", objNull];
//_unit action ["User", _unit, _actionArsenal];
//_unit removeAction _actionArsenal;

if (!_didJIP || {!started}) then 
{
	hint parseText 
	"
		<t align='left'>Respawn:</t> <t align='right' color='#6699CC'>Enabled</t><br />
		<t align='left'>Start time</t> <t align='right' color='#6699CC'>10:00 AM</t><br /><br />
		
		<t size='1.75'>Waiting for Ops</t><br />
		<t size='0.75'>v. 2.0</t><br />
		<t size='0.75'>by Love Stole the Day</t><br />
		<t size='0.75'>(original Holdout by Staticky)</t><br />
		
		
		Hold out for as long as you can against endless waves of enemy forces!  Choose your base, and choose where the waves will come from! <br /><br />
		
		To begin the mission, use the '<t color='#66DD99'>Mission Setup</t>' action located at the whiteboard that has the map of Altis on it.  Once the setup is completed, all players, along with an Arsenal crate, will teleport to the AO and begin the mission!
	";
};