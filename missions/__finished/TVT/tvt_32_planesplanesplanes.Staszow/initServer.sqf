enableSaving [false, false];
enableSentences false;

sv_debug = isMultiplayer; publicVariable "sv_debug";

[	//serverside initialization of the vanilla U-menu feature for group management
	"Initialize"
] call BIS_fnc_dynamicGroups;

//mission setup
sv_unitMarkerList = [];

//for AI use
sxf_fnc_prepareAircraft = compile preprocessFileLineNumbers "scripts\fnc_prepareAircraft.sqf";

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

[] spawn {
	{	//set the AI players up with their jets, if there are any...
		if (!isPlayer _x && {side _x in [blufor, opfor]}) then {
			_jetSpawnPos = [0,0,0];
			_spawnDir = 0;
			_chosenPlane = "";
			switch (side _x) do
			{
				case blufor: 
				{
					_jetSpawnPos = getMarkerPos "blufor-spawn";
					_spawnDir = 225;
					_chosenPlane = (sv_bluforPlanes) select floor random count (sv_bluforPlanes);
				};
				case opfor: 
				{
					_jetSpawnPos = getMarkerPos "opfor-spawn";
					_spawnDir = 45;
					_chosenPlane = (sv_opforPlanes + sv_indforPlanes) select floor random count (sv_opforPlanes + sv_indforPlanes);
				};
			};
			_jetSpawnPos set [0, (_jetSpawnPos select 0) + (random 512)];
			_jetSpawnPos set [1, (_jetSpawnPos select 0) + (random 512)];
			_jetSpawnPos set [2, 500 + (floor random 200)];
			_jet = createVehicle [_chosenPlane, _jetSpawnPos, [], 0, "FLY"];
			[_x, _jet] remoteExec["moveInDriver", _x];
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
					_unit setDamage 1;	//this will activate the MPKilled trigger, which will delete their marker
				}
			];
			
			sleep 1; //so that we know that the mission has started
			
			_markerName = ("ai_" + str (random 1000));
			sv_unitMarkerList pushBack 
			[
				_x,
				(createMarker [_markerName, position _x])
			];
			_x setVariable ["myMarkerName", _markerName, true];	//so that we can know which marker belongs to which player
			_markerName setMarkerType "mil_arrow2";
			_markerName setMarkerSize [0.8, 0.8];
			
			switch (side _x) do
			{
				case blufor: 	//TEAM GOLD (0->fuselage, 1->wings)
				{
					(vehicle _x) setObjectTextureGlobal [0, "#(rgb,8,8,3)color(1,0.2,0,1)"];
					(vehicle _x) setObjectTextureGlobal [1, "#(rgb,8,8,3)color(1,0.15,0,0.7)"];
					(vehicle _x) spawn sxf_fnc_prepareAircraft;
					_markerName setMarkerColor "ColorOrange";
				};
				case opfor: 	//TEAM GREEN (0->fuselage, 1->wings)
				{
					(vehicle _x) setObjectTextureGlobal [0, "#(rgb,8,8,3)color(0.35,1,0.65,0.325)"];
					(vehicle _x) setObjectTextureGlobal [1, "#(rgb,8,8,3)color(0.35,1,0.65,0.1)"];
					(vehicle _x) spawn sxf_fnc_prepareAircraft;
					_markerName setMarkerColor "ColorGreen";
				};
			};
			
			_x flyInHeight 500;
			[_x, false] call ace_medical_fnc_setUnconscious;
		};
	} forEach allUnits;
};

addMissionEventHandler [
	"EntityKilled",
	{
		params ["_killed", "_killer", "_instigator"];
		_markerName = _killed getVariable ["myMarkerName", ""];
		if (!isNil _markerName) then {
			deleteMarker _markerName;
			sv_unitMarkerList = sv_unitMarkerList - [_killed, _markerName];
		};
		if (_killed isKindOf "Man") then { deleteVehicle _killed; };
		if (isPlayer driver _killer) then {
			parseText format ["<t align='left' size=1.5>You shot down<br/><t align='center'>%1</t></t>", name driver _killed] remoteExec ["hint", driver _killer];
		};
	}
];

waitUntil {count sv_unitMarkerList > 0};

while {count sv_unitMarkerList > 0} do
{
	{
		_thisUnit	= _x select 0;
		_thisMarker	= _x select 1;
		
		_thisMarker setMarkerPos (position _thisUnit);
		if (!isPlayer _thisUnit) then {
			_thisMarker setMarkerText "p" + str(_forEachIndex) + ", " + str ( round ( (getPosASL _thisUnit select 2) / 1000) ) + "km";
		} else {
			_temp = toArray (name _thisUnit);
			_temp resize 3;
			_temp = toString _temp;
			_thisMarker setMarkerText _temp + ", " + str ( round ( (getPosASL _thisUnit select 2) / 1000) ) + "km";
		};
		_thisMarker setMarkerDir (getDir _thisUnit);
	} forEach sv_unitMarkerList;
	
	sleep 1;
};