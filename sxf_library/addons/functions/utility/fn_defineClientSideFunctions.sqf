// DO NOT CALL THIS FUNCTION IN A MISSION!
// This script is automatically called when the mission is loaded, before objects are initialized.
// The purpose of this script is only to publicVariable the functions that we want to be able to use on the ClientSide!



{
	_name = ("SXF_" + _x);
	_listOfFunctions = (configFile >> "CfgFunctions" >> _name >> "GlobalFunctions") call BIS_fnc_getCfgSubClasses;
	{
		publicVariable ( _name + "_fnc_" + _x );
	} forEach _listOfFunctions;
} forEach ["Init", "Utility"];