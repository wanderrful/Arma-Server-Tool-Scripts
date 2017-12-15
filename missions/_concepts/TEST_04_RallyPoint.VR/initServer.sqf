sv_RallyPointObjectClass = "Land_TentDome_F";

sxf_fnc_createRallyPoint = {
	_rallyPoint = sv_RallyPointObjectClass createVehicle getPosATL _this;
	_this setVariable [ "sxf_fnc_ListOfCreatedRallyPoints", _rallyPoint, true ];
	[ group _this, getPosATL _rallyPoint ] call BIS_fnc_addRespawnPosition;
	[ _rallyPoint, 9, true ] call BIS_fnc_respawnTickets; 
	{
		_rallyPoint disableCollisionWith _x;
	} forEach (call BIS_fnc_listPlayers);
};
sxf_fnc_destroyRallyPoint = {
	
};