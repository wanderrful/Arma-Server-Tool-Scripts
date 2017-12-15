//context: client-side
params ["_newUnit", "_oldUnit", "_respawnMode", "_respawnDelay"];

["Terminate"] call BIS_fnc_EGSpectator;

_newUnit enableFatigue false;

[player] joinSilent passivePlayerGroup;
_newUnit setDir (markerDir "respawn_west");

_newUnit addMPEventHandler [	//inception?
	"MPRespawn",
	{
		params ["_unit", "_corpse"];
		deleteVehicle _corpse;
	}
];

removeAllWeapons _newUnit;
//removeUniform _newUnit;
//_newUnit unlinkItem "NVGoggles_INDEP";
//_newUnit forceAddUniform "U_IG_leader";

[_newUnit, "hgun_rook40_F", 5] call BIS_fnc_addWeapon;

_newUnit addItem "FirstAidKit"; _newUnit addItem "FirstAidKit"; _newUnit addItem "FirstAidKit"; _newUnit addItem "FirstAidKit"; _newUnit addItem "FirstAidKit";