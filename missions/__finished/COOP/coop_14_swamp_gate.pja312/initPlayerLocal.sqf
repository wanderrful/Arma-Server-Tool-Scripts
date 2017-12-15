params ["_unit", "_didJIP"];



[ "InitializePlayer", [_unit] ] call BIS_fnc_dynamicGroups; // clientside initialization of the vanilla U-menu feature for group management 
enableSentences false;



cl_isRadioman = (vehicleVarName player) in ["p_16", "p_17"];



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



// fixing the loadouts
player unlinkItem "ItemRadio";
player unlinkItem (hmd player);



// define the team unit names that i assigned in the editor in case I want to use them here at all
sv_TeamAdam = [
	"p_1",
	"p_2",
	"p_8",
	"p_13",
	"p_14",
	"p_16"
];
sv_TeamBond = [
	"p_4",
	"p_10",
	"p_15",
	"p_17",
	"p_18",
	"p_3"
];
sv_TeamCaesar = [
	"p_7",
	"p_9"
];