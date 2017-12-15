//*** Define the initial settings
sv_debug = (count call BIS_fnc_listPlayers <= 1); publicVariable "sv_debug";
[ "Initialize" ] call BIS_fnc_dynamicGroups; //serverside initialization of the vanilla U-menu feature for group management
enableSentences false;



//*** Define the special stuff for this mission
sxf_fnc_sendPlayerToCarrier = {
	_pos = getMarkerPos "carrier_respawn";
	_pos set [2, 23];
	_this setPosASL _pos;
};



//*** Move the player to the carrier when respawned
addMissionEventHandler [ "EntityRespawned", {
	params ["_unit", "_oldUnit"];
	if (isPlayer _unit) then {
		_unit call sxf_fnc_sendPlayerToCarrier;
		deleteVehicle _oldUnit;
	};
}];



//*** Configure the looping hint message of which players can opt-in or out as they please.
sxf_fnc_loopMessage = {	
	_output = "";
	
	_enemyCountMessage = format [ "<br/><t size='1.5'><t align='left'>Jets remaining:</t> <t color='#E28014' align='right'>%1</t></t><br/>", opfor countSide allUnits ];
	_timerMessage = "";

	_livingPlayersMessage = "<t align='left' size='1.3'>Players remaining:</t><br/>";
	{
		if (isPlayer _x && {! ( str side _x isEqualTo "LOGIC" ) }) then {
			_color = "#666666";	//dead color by default
			if (alive _x) then {
				_color = ["#FFFFFF", "#F1BD1D"] select ( lifeState _x isEqualTo "INCAPACITATED" );
			};
			_livingPlayersMessage = _livingPlayersMessage + format [
				"<t align='left'>  +  <t color='%1'>%2</t><br/>", 
				_color, 
				name _x
			];
		};
	} forEach ( [allUnits, call BIS_fnc_listPlayers] select isMultiplayer );
	
	_output = (
		_enemyCountMessage + 
		"<br/><br/>" +
		_timerMessage +
		"<br/><br/>" +
		_livingPlayersMessage +
		"<br/><br/>"
	);
	
	{	//show the mission info hint message only to the players who have their loop message turned ON
		if (_x getVariable ["sxf_bLoopEnabled", false]) then {
			(parseText _output) remoteExec ["hintSilent", _x];
		};
	} forEach (call BIS_fnc_listPlayers);
};
[ "itemAdd", [ "loopMessage", {
		call sxf_fnc_loopMessage; 
	}, 1, "seconds", {
		{_x getVariable ["sxf_bLoopEnabled", false]} count (call BIS_fnc_listPlayers) > 0  
	} 
] ] call BIS_fnc_loop;