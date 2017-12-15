_pos = [_this select 0, _this select 1,_this select 2];
		
"spawn_east" setmarkerpos [_pos select 0, _pos select 1, 100];
"spawn_east" setMarkerShape "ICON";
"spawn_east" setMarkerType "hd_warning";
"spawn_east" setMarkerColor "ColorRed";


hint format["Done"];
onMapSingleClick "";

sleep 0.5;
closedialog 0;
sleep 0.5;
hint format["Click on the position you would like the attacker to come from (3/4)."];
openMap [true, true];
onMapSingleClick "[_pos select 0, _pos select 1, 8] execVM 'scripts\setup\placement3.sqf'; True";