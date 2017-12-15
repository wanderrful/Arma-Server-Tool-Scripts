sv_debug = true; publicVariable "sv_debug";

{
	if (!isPlayer _x) then
	{
		_x disableAI "AUTOCOMBAT";
		_x disableAI "MOVE";
	};
} forEach allUnits;