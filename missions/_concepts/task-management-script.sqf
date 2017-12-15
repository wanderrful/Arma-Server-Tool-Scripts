//this function must be SPAWNED!
fn_objComplete =  {
	params ["_obj1Text", "_obj2Text"];

	["TaskSuceeded", ["", _obj1Text]] call BIS_fnc_showNotification;
	["ObjectiveCompleted"] call BIS_fnc_showNotification;
	playSound "ObjectiveCompleted";

	sleep 3;

	["TaskAssigned", ["", _obj2Text]] call BIS_fnc_showNotification;
};