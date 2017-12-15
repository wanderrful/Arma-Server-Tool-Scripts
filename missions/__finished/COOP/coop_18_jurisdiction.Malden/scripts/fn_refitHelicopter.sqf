//this function is meant to be called from a trigger's action statement, with thisList as its only argument.

//this function should work for any aircraft!

//if (sv_debug) then { hint format["fnc_refitAircraft.sqf called!  Arguments: %1", _this]; };

_vehicle = _this select 0;

if ( !(_vehicle isKindOf "Air") ) exitWith {};



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
{
	_magazineClassName = _x select 0;
	_turretPath = _x select 1;
	_maxAmount = getNumber (configfile >> "CfgMagazines" >> _magazineClassName >> "count");
	[ _vehicle, [_magazineClassName, _maxAmount, _turretPath] ] remoteExec ["setMagazineTurretAmmo", (driver _vehicle)];
} forEach ( magazinesAllTurrets _vehicle );



//*** REFUEL AIRCRAFT
[_vehicle, 0.5] remoteExec ["setFuel", driver _vehicle];



//*** REPAIR AIRCRAFT
_vehicle setDamage 0;



//*** REFIT COMPLETED!
["TaskSucceeded", ["", "Aircraft refit!"]] remoteExec ["BIS_fnc_showNotification", driver _vehicle];
[_vehicle, true] remoteExec ["engineOn", driver _vehicle];