// (Serverside) Begins sending hint messages to the players who have opted in by setting their "sxf_bLoopEnabled" variable to true.

[ "itemAdd", [ "loopMessage", {

	_output = "";
	
	// Enemy Count
	_enemyCountMessage = format [ "<br/><t size='1.5'><t align='left'>Enemies remaining:</t> <t color='#E28014' align='right'>%1</t></t><br/>", opfor countSide allUnits ];

	// Timer
	_timerMessage = "";
	if (!isNil "sv_currentTime") then {
		if (sv_currentTime >= 0) then {
			_timerMessage = _timerMessage + "<t size='1.3'>Time remaining:</t><br/>";
			_timerMessage = _timerMessage + format["<t size='2' align='center' color='#F1BD1D'>%1m %2s</t>", floor abs (sv_currentTime/60), (abs sv_currentTime)%60];
		} else {
			_timerMessage = _timerMessage + "<t size='1.3'>Time elapsed:</t><br/>";
			_timerMessage = _timerMessage + format["<t size='2' align='center' color='#F1BD1D'>%1m %2s</t>", floor abs (sv_currentTime/60), (abs sv_currentTime)%60];
		};
	};
	
	// Player Status
	_livingPlayersMessage = "<t align='left' size='1.3'>Players remaining:</t><br/>";
	{
		if (isPlayer _x && {! ( str side _x isEqualTo "LOGIC" ) }) then {
			_color = "#666666";	//dead color by default
			if (alive _x) then {
				//cannot do the usual getvariable here because this is all serverside and Bohemia doesn't replicate that info to the server
				_color = ["#FFFFFF", "#F1BD1D"] select ( lifeState _x isEqualTo "INCAPACITATED" );
			};
			_livingPlayersMessage = _livingPlayersMessage + format [
				"<t align='left'>  +  <t color='%1'>%2</t><br/>", 
				_color, 
				name _x
			];
		};
	} forEach ( [allUnits, call BIS_fnc_listPlayers] select isMultiplayer );
	
	// Compile the above data
	_output = (
		_enemyCountMessage + 
		"<br/><br/>" +
		_timerMessage +
		"<br/><br/>" +
		_livingPlayersMessage +
		"<br/><br/>"
	);
	
	// Show the mission info hint message only to the players who have opted in
	{	
		if (_x getVariable ["sxf_bLoopEnabled", false]) then {
			(parseText _output) remoteExec ["hintSilent", _x];
		};
	} forEach (call BIS_fnc_listPlayers);
	
}, 1, "seconds", {
	{_x getVariable ["sxf_bLoopEnabled", false]} count (call BIS_fnc_listPlayers) > 0  
} ] ] call BIS_fnc_loop;