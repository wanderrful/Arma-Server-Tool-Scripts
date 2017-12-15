[	//turn on the built-in group management thing
	"Initialize"
] call BIS_fnc_dynamicGroups;


//these are the boilerplate TFB settings for TFR radio stuff
tf_give_personal_radio_to_regular_soldier = false;
publicVariable "tf_give_personal_radio_to_regular_soldier";

tf_no_auto_long_range_radio = true;
publicVariable "tf_no_auto_long_range_radio";

tf_same_sw_frequencies_for_side = true;
publicVariable "tf_same_sw_frequencies_for_side";

tf_same_lr_frequencies_for_side = true;
publicVariable "tf_same_lr_frequencies_for_side";

_settingsSwWest = false call TFAR_fnc_generateSwSettings;
_settingsSwWest set [2, ["311","312","313","314","315","316","317","318 "]];
tf_freq_west = _settingsSwwest;
publicVariable "tf_freq_west";

_settingsLrWest = false call TFAR_fnc_generateLrSettings;
_settingsLrWest set [2, ["40","41","42","43","44","45","46","47","48"]];
tf_freq_west_lr = _settingsLrwest;
publicVariable "tf_freq_west_lr";

_settingsSwEast = false call TFAR_fnc_generateSwSettings;
_settingsSwEast set [2, ["311","312","313","314","315","316","317","318 "]];
tf_freq_west = _settingsSwEast;
publicVariable "tf_freq_East";

_settingsLrEast = false call TFAR_fnc_generateLrSettings;
_settingsLrEast set [2, ["40","41","42","43","44","45","46","47","48"]];
tf_freq_west_lr = _settingsLrEast;
publicVariable "tf_freq_East_lr";