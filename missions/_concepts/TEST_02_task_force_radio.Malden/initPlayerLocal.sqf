_bIsTFREnabled = isClass (configfile >> "CfgPatches" >> "task_force_radio");
if (_bIsTFREnabled) then {
	//configure the CLIENTSIDE TFR settings

	//make all sides able to communicate via radio
	{ _x = "_bluefor"; } forEach [tf_west_radio_code, tf_east_radio_code, tf_guer_radio_code];

	{
		missionNamespace setVariable [format ["TF_%1_radio_code", _x], "your radio code here", true];
	} forEach [blufor,opfor,"independent"];
};