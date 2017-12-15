_pos = [_this select 0, _this select 1,_this select 2];
		
"spawn_west" setmarkerpos [_pos select 0, _pos select 1, 100];
"spawn_west" setMarkerShape "ICON";
"spawn_west" setMarkerType "hd_warning";
"spawn_west" setMarkerColor "ColorRed";

hint format["Done"];
onMapSingleClick "";

sleep 0.5;
[
	{
		hint parseText format["<t size='1.5'>Setup complete!</t><br /><br />You can now teleport to the AO using the whiteboard."];
		whiteboardAction = whiteBoard addAction ["Teleport to the AO!", {preloadCamera getMarkerPos 'town'; player setPos [5+(getMarkerPos 'town' select 0), getMarkerPos 'town' select 1, 0];}];
	}, 
	"bis_fnc_spawn"
] call BIS_fnc_mp;

openMap [false, false];

sleep 2;

started = true;
publicVariable "started";