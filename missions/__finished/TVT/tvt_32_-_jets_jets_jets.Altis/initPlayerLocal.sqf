params ["_unit", "_didJIP"];

[ "InitializePlayer", [_unit] ] call BIS_fnc_dynamicGroups; //clientside initialization of the vanilla U-menu feature for group management 


//just in case this thing breaks somehow and people can shoot eachother at their spawn locations in the editor
removeAllWeapons _unit;


//declare the clientside functions needed for this mission
sxf_fnc_prepareAircraft = compile preprocessFileLineNumbers "scripts\fnc_prepareAircraft.sqf";



//trigger that will warn player to descend or ascend to within the flight ceiling/floor limits
// use this function: ["<t color='#ff0000' size = '.8'>Warning!<br />You are above the flight ceiling for this mission (10km).  You must descend. </t>",-1,-1,4,1,0,789] spawn BIS_fnc_dynamicText;


_jetSpawnPos = [0,0,0];
_spawnDir = 0;
switch (side _unit) do
{
	case blufor: 
	{
		_jetSpawnPos = getMarkerPos "blufor-spawn";
		_spawnDir = 225;
	};
	case opfor: 
	{
		_jetSpawnPos = getMarkerPos "opfor-spawn";
		_spawnDir = 45;
	};
};
_jetSpawnPos set [0, (_jetSpawnPos select 0) + (random 512)];
_jetSpawnPos set [1, (_jetSpawnPos select 0) + (random 512)];
_jetSpawnPos set [2,9100 + floor random 200];
_jet = createVehicle ["O_Plane_CAS_02_F", _jetSpawnPos, [], 0, "FLY"];
player moveInDriver _jet;
_jet setPosASL _jetSpawnPos;
_jet setDir _spawnDir;

_vel = velocity _jet;
_dir = direction _jet;
_speed = 350;
_jet setVelocity [
	(_vel select 0) + (sin _dir * _speed), 
	(_vel select 1) + (cos _dir * _speed), 
	(_vel select 2)
];

_jet addEventHandler [
	"GetOut",	//maybe i'll have to replace this event with a trigger that keeps track for "Steerable_Parachute_F" as the "typeOf vehicle _unit"
	{
		params ["_vehicle", "_position", "_unit", "_turret"];
		player setDamage 1;	//this will activate the MPKilled trigger, which will delete their marker
	}
];


waitUntil {time>0};

_markerName = _unit getVariable ["myMarkerName", ""];
switch (side _unit) do
{
	case blufor: 	//TEAM GOLD (0->fuselage, 1->wings)
	{
		(vehicle _unit) setObjectTextureGlobal [0, "#(rgb,8,8,3)color(1,0.2,0,1)"];
		(vehicle _unit) setObjectTextureGlobal [1, "#(rgb,8,8,3)color(1,0.15,0,0.7)"];
		(vehicle _unit) spawn sxf_fnc_prepareAircraft;
		_markerName setMarkerColor "ColorOrange";
	};
	case opfor: 	//TEAM GREEN (0->fuselage, 1->wings)
	{
		(vehicle _unit) setObjectTextureGlobal [0, "#(rgb,8,8,3)color(0.35,1,0.65,0.325)"];
		(vehicle _unit) setObjectTextureGlobal [1, "#(rgb,8,8,3)color(0.35,1,0.65,0.1)"];
		(vehicle _unit) spawn sxf_fnc_prepareAircraft;
		_markerName setMarkerColor "ColorGreen";
	};
};









//intro message stuff

_lineBreakString = "<br/><br/>------------------<br/><br/>";

_myTeamMessage = "";
if (side _unit == blufor) then { _myTeamMessage = "<t size='1.5'>You are on the <t color='#FFA500'>GOLD</t> team</t>.<br/>Shoot the <t color='#76EE00'>GREEN</t> guys!"; };
if (side _unit == opfor) then { _myTeamMessage = "<t size='1.5'>You are on the <t color='#76EE00'>GREEN</t> team</t><br/>Shoot the <t color='#FFA500'>GOLD</t> guys!"; };

_missionInfoMessage = "<t size='1.25'><t align='left'>FLIGHT CEILING:</t> <t align='right'>10km</t><br/><t align='left'>FLIGHT FLOOR:</t> <t align='right'>5km</t></t>";

_extraInfoMessage = "<t size='1.5'>TIPS:</t><br/>-- You can use your <t color='#BF3EFF'>map and GPS</t> to find other players in case you get lost or can't see anyone.<br/>-- It's okay to increase your <t color='#BF3EFF'>View Distance and Object Distance</t> to 5km (missile range) for this mission because of the extremely high altitude.<br/>-- <t color='#BF3EFF'>	Your ammo will automatically reload</t> when you run out after a 10 or 15 second cooldown, so it's effectively infinite.<br/>-- You can re-read this information by checking the <t color='#BF3EFF'>Briefing</t> in your map menu.";


hint parseText ("<br/>" + _myTeamMessage + _lineBreakString + _missionInfoMessage + _lineBreakString + _extraInfoMessage + "<br/>");