//CONTEXT: serverside
params ["_unit"];

_markerName = "unit" + str(_forEachIndex);
sv_unitMarkerList pushBack 
[
	_unit,
	(createMarker [_markerName, position _unit])
];
_unit setVariable ["myMarkerName", _markerName, true];	//so that we can know which marker belongs to which player
_markerName setMarkerType "mil_arrow2";
_markerName setMarkerSize [0.8, 0.8];

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

(vehicle _unit) addEventHandler
[
	"GetOut",	//maybe i'll have to replace this event with a trigger that keeps track for "Steerable_Parachute_F" as the "typeOf vehicle _unit"
	{
		params ["_vehicle", "_position", "_unit", "_turret"];
		_unit setDamage 1;	//this will activate the MPKilled trigger, which will delete their marker
	}
];
_unit addMPEventHandler
[
	"MPKilled",
	{
		//context: both clientside and serverside
		params ["_unit", "_killer"];
		
		if (isServer) then
		{
			_tempMarkerName = _unit getVariable "myMarkerName";
			deleteMarker _tempMarkerName;
			//remove its entry from sv_unitMarkerList
			sv_unitMarkerList = sv_unitMarkerList - [_unit, _tempMarkerName];
			deleteVehicle _unit;
		};
	}
];