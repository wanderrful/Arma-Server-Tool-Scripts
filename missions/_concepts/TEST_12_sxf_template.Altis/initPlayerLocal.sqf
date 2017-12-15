params ["_unit", "_didJIP"];



//if the player has a radio backpack, replace it with the TFR backpack!




// Add the F-key bindings that I like to use for my missions 
call SXF_Init_fnc_initSpecialHotkeys;

// Disable the Saving and Loading buttons on the Arsenal so that people can't bypass the whitelisting
call SXF_Utility_fnc_disableArsenalSavingLoading;
