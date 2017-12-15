params ["_unit", "_didJIP"];


if (_didJIP) then
{
	if (!isNil "sv_unitMarkerList") then	//this should never return false, but just in case...
	{
		_markerName = "unit" + str( 32 + (floor random 1000) );	//this is my shitty attempt at making sure that JIPs don't fuck up the marker name thing...
		sv_unitMarkerList pushBack 
		[
			_unit,
			(createMarker [_tempMarkerName, position _unit])
		];
		_unit setVariable ["myMarkerName", _markerName];
	};
};


_markerName = "unit" + str( (count call BIS_fnc_listPlayers) + random 999);
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