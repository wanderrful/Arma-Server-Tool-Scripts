params ["_unit", "_didJIP"];



[ "InitializePlayer", [_unit] ] call BIS_fnc_dynamicGroups; //clientside initialization of the vanilla U-menu feature for group management 
enableSentences false;



cl_isRadioman = (vehicleVarName player) in ["p_8", "p_9", "p_16"];



// if using TFR and wearing a radio backpack... swap it out!
if ( isClass (configFile >> "CfgPatches" >> "task_force_radio") ) then {
	if ( cl_isRadioman ) then {
		removeBackpack player;
		player addBackpack "tf_anprc155_coyote";
	};
};



// Add the F-key bindings that I like to use for my missions 
call SXF_Init_fnc_initSpecialHotkeys;

// Disable the Saving and Loading buttons on the Arsenal so that people can't bypass the whitelisting
call SXF_Utility_fnc_disableArsenalSavingLoading;



waitUntil { time > 0 };



player action ['SwitchWeapon', player, player, 99];



//fixing the loadouts
player unlinkItem "ItemRadio";
player unlinkItem (hmd player);