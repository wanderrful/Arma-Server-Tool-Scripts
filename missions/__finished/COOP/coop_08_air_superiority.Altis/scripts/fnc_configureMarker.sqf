//if (sv_debug) then { hint format["fnc_configureMarker.sqf called!  Arguments: %1", _this]; };

_jet = _this;

_marker = createMarker [ "marker_jet_" + str count sv_aircraftMarkerList, position _jet ];

_side = getNumber (configFile >> "CfgVehicles" >> typeOf _jet >> "side");

switch (_side) do {
	case 0: { //opfor
		_marker setMarkerColor "ColorRed";
	};
	case 1: { //blufor
		_marker setMarkerColor "ColorBlue";
	};
	case 2: { //indfor
		_marker setMarkerColor "ColorGreen";
	};
	default {
		_marker setMarkerColor "ColorUNKNOWN";
	};
};

_marker setMarkerSize [0.6, 0.6];
_marker setMarkerType "Empty";

_index = sv_aircraftMarkerList pushBack _marker;

_jet setVariable ["sxf_markerIndex", _index, true];