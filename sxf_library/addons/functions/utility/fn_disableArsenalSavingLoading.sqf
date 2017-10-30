// CLIENTSIDE
if (!hasInterface) exitWith {};



//*** Disable Saving and Loading of Arsenal loadouts!
[ missionNamespace, "arsenalOpened", {
    disableSerialization;
    _display = _this select 0;
    {
        ( _display displayCtrl _x ) ctrlSetText "Disabled";
        ( _display displayCtrl _x ) ctrlSetTextColor [ 1, 0, 0, 0.5 ];
        ( _display displayCtrl _x ) ctrlRemoveAllEventHandlers "buttonclick";
				
		_display displayAddEventHandler ["KeyDown", "if ((_this select 1) in [19,24,29,31]) then {true};"];
    } forEach [ 44146, 44147, 44150 ];
} ] call BIS_fnc_addScriptedEventHandler;