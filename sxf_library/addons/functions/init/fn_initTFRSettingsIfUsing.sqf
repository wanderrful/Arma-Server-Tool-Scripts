_bIsTFREnabled = isClass (configFile >> "CfgPatches" >> "task_force_radio");
if (_bIsTFREnabled) then {
	{
		missionNamespace setVariable [ format ["tf_%1_radio_code", _x], "radio_code", true ];
	} forEach [blufor,opfor,"guer"]; 
	// ^ use a string for independent because TFR uses it to represent both the indfor and civilians sides


/*
	if(isServer) then {
		TFAR_defaultFrequencies_sr_west = ["31","32","33","36","35","36","37","38","39"];
		TFAR_defaultFrequencies_lr_west = ["61","62","63","66","65","66","67","68","69"];
		TFAR_defaultFrequencies_sr_east = ["31","32","33","36","35","36","37","38","39"];
		TFAR_defaultFrequencies_lr_east = ["61","62","63","66","65","66","67","68","69"];
		TFAR_defaultFrequencies_sr_independent = ["31","32","33","36","35","36","37","38","39"];
		TFAR_defaultFrequencies_lr_independent = ["61","62","63","66","65","66","67","68","69"];
	};
*/
};