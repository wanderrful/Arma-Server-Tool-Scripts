//this function is meant to be called from a trigger's action statement, with thisList as its only argument.

//if (sv_debug) then { hint format["fnc_refitAircraft.sqf called!  Arguments: %1", _this]; };

_vehicle = _this select 0;

if ( !(_vehicle isKindOf "Plane") ) exitWith {};



[ _vehicle, 0 ] remoteExec ["setAirplaneThrottle", driver _vehicle];
[ _vehicle, [0,0,0] ] remoteExec ["setVelocity", driver _vehicle];
[_vehicle, false ] remoteExec ["engineOn", driver _vehicle];



//DEPRECATED -- cancel the refit process if the player turns their engine back on!
_temp_fnc_cancelRefit = {
	["TaskFailed", ["", "Refit failed!"]] remoteExec ["BIS_fnc_showNotification", driver _vehicle];
	
	[
		_vehicle,
		"*** Throttle must remain at zero in order to refit the aircraft!"
	] remoteExec ["vehicleChat", driver _vehicle];
	[
		_vehicle,
		"*** Please exit the refit zone and try again!"
	] remoteExec ["vehicleChat", driver _vehicle];
};



["TaskUpdated", ["", "Refitting Aircraft..."]] remoteExec ["BIS_fnc_showNotification", driver _vehicle];
sleep 3;
if (airplaneThrottle _vehicle > 0) exitWith { call _temp_fnc_cancelRefit; };



//*** REARM AIRCRAFT
_Jet_Loadout =["PylonRack_Missile_AMRAAM_D_x1","PylonRack_Missile_AMRAAM_D_x1","PylonRack_Missile_AMRAAM_D_x1","PylonRack_Missile_AMRAAM_D_x1","","","PylonMissile_Missile_AMRAAM_D_INT_x1","PylonMissile_Missile_AMRAAM_D_INT_x1","PylonMissile_Missile_AMRAAM_D_INT_x1","PylonMissile_Missile_AMRAAM_D_INT_x1","PylonMissile_Missile_AMRAAM_D_INT_x1","PylonMissile_Missile_AMRAAM_D_INT_x1"];

private _pylons = _Jet_Loadout;
private _pylonPaths = (configProperties [configFile >> "CfgVehicles" >> typeOf _vehicle >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply {getArray (_x >> "turret")};
{ 
	_vehicle removeWeaponGlobal getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon") 
} forEach getPylonMagazines _vehicle;
{ 
	_vehicle setPylonLoadOut [_forEachIndex + 1, _x, true, _pylonPaths select _forEachIndex]; 
} forEach _pylons;

//resupply the ammo for the gun because it's not on a pylon
[ _vehicle, ["magazine_Fighter01_Gun20mm_AA_x450", 450, [-1]] ] remoteExec ["setMagazineTurretAmmo", (driver _vehicle)];
[ _vehicle, ["240Rnd_CMFlare_Chaff_Magazine", 240, [-1]] ] remoteExec ["setMagazineTurretAmmo", (driver _vehicle)];



//*** REFUEL AIRCRAFT
[_vehicle, 0.5] remoteExec ["setFuel", driver _vehicle];



//*** REPAIR AIRCRAFT
_vehicle setDamage 0;



//*** REFIT COMPLETED!
["TaskSucceeded", ["", "Aircraft refit!"]] remoteExec ["BIS_fnc_showNotification", driver _vehicle];
[_vehicle, true] remoteExec ["engineOn", driver _vehicle];