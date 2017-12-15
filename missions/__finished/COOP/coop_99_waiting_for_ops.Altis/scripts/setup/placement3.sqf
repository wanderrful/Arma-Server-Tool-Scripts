_pos = [_this select 0, _this select 1,_this select 2];
		
"spawn_south" setmarkerpos [_pos select 0, _pos select 1, 100];
"spawn_south" setMarkerShape "ICON";
"spawn_south" setMarkerType "hd_warning";
"spawn_south" setMarkerColor "ColorRed";

hint format["Done"];
onMapSingleClick "";

sleep 0.5;
closedialog 0;
sleep 0.5;
hint format["Click on the position you would like the attacker to come from (4/4)."];
openMap [true, true];
onMapSingleClick "[_pos select 0, _pos select 1, 8] execVM 'scripts\setup\placement4.sqf'; True";