params ["_unit", "_didJIP"];

[	//clientside initialization of the vanilla U-menu feature for group management
	"InitializePlayer",
	[
		_unit
	]
] call BIS_fnc_dynamicGroups;


//just in case this thing breaks somehow and people can shoot eachother at their spawn locations in the editor
removeAllWeapons _unit;


//declare the clientside functions needed for this mission
sxf_fnc_prepareAircraft = compile preprocessFileLineNumbers "scripts\fnc_prepareAircraft.sqf";



//trigger that will warn player to descend or ascend to within the flight ceiling/floor limits
// use this function: ["<t color='#ff0000' size = '.8'>Warning!<br />You are above the flight ceiling for this mission (10km).  You must descend. </t>",-1,-1,4,1,0,789] spawn BIS_fnc_dynamicText;



sv_bluforPlanes = [ //german
	"LIB_FW190F8",
	"LIB_FW190F8_Italy",
	"LIB_FW190F8_4",
	"LIB_FW190F8_4",
	"LIB_FW190F8_2",
	"LIB_FW190F8_5",
	"LIB_FW190F8_3",
	"LIB_DAK_FW190F8"
];
sv_opforPlanes = [ //russian
	"LIB_P39_w",
	"LIB_P39",
	"LIB_RA_P39_3",
	"LIB_RA_P39_2"
];
sv_indforPlanes = [	//american and british
	"LIB_ACI_P39",
	"LIB_RAAF_P39",
	"LIB_RAF_P39",
	"LIB_US_P39",
	"LIB_US_P39_2",
	"LIB_P47",
	"LIB_US_NAC_P39_2",
	"LIB_US_NAC_P39_3",
	"LIB_US_NAC_P39"
];
_chosenPlane = "";
if (side _unit isEqualTo blufor) then { _chosenPlane = (sv_bluforPlanes) select floor random count (sv_bluforPlanes); };
if (side _unit isEqualTo opfor) then { _chosenPlane = (sv_opforPlanes + sv_indforPlanes) select floor random count (sv_opforPlanes + sv_indforPlanes); };



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
_jetSpawnPos set [2,500 + floor random 200];
_jet = createVehicle [_chosenPlane, _jetSpawnPos, [], 0, "FLY"];
player moveInDriver _jet;
_jet engineOn true;
_jet setPosASL _jetSpawnPos;
_jet setDir _spawnDir;

_vel = velocity _jet;
_dir = direction _jet;
_speed = 200;
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

addMissionEventHandler [
	"EachFrame",
	{
		if (!alive player) then { removeAllMissionEventHandlers "EachFrame"; };
		if (player getVariable ["ACE_isUnconscious", true]) then { [player, false] call ace_medical_fnc_setUnconscious; };
	}
];









//intro message stuff

_lineBreakString = "<br/><br/>------------------<br/><br/>";

_myTeamMessage = "";
if (side _unit isEqualTo blufor) then { _myTeamMessage = "<t size='1.5'>You are on the <t color='#FFA500'>GOLD</t> team</t>.<br/>Shoot the <t color='#76EE00'>GREEN</t> guys!"; };
if (side _unit isEqualTo opfor) then { _myTeamMessage = "<t size='1.5'>You are on the <t color='#76EE00'>GREEN</t> team</t><br/>Shoot the <t color='#FFA500'>GOLD</t> guys!"; };

_missionInfoMessage = "";

_extraInfoMessage = "<t size='1.5'>TIPS:</t><br/>-- You can use your <t color='#BF3EFF'>map</t> to find other players in case you get lost or can't see anyone.<br/>-- You will probably need to increase your <t color='#BF3EFF'>View Distance and Object Distance</t> for this mission.<br/>-- <t color='#BF3EFF'>	Your ammo will automatically reload</t> when you run out after a 10 second cooldown, so it's effectively infinite.<br/>-- You can re-read this information by checking the <t color='#BF3EFF'>Briefing</t> in your map menu.";


hint parseText ("<br/>" + _myTeamMessage + _lineBreakString + _missionInfoMessage + _lineBreakString + _extraInfoMessage + "<br/>");