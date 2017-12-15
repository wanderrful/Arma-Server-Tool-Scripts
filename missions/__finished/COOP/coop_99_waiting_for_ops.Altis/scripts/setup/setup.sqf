[{whiteBoard removeAction whiteboardAction;}, "bis_fnc_spawn"] call BIS_fnc_mp;

closedialog 0;
sleep 0.5;
hint format["Click on the position you would like to defend."];
openMap [true, true];
onMapSingleClick "[_pos select 0, _pos select 1, 8] execVM 'scripts\setup\townplacement.sqf'; True";