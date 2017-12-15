_pos = [_this select 0, _this select 1,_this select 2];
		
"spawn_north" setMarkerPos [_pos select 0, _pos select 1, 100];
"spawn_north" setMarkerShape "ICON";
"spawn_north" setMarkerType "hd_warning";
"spawn_north" setMarkerColor "ColorRed";


hint format["Done"];
onMapSingleClick "";

sleep 0.5;
closedialog 0;
sleep 0.5;
hint format["Click on the position you would like the attacker to come from (2/4)."];
openMap [true, true];
onMapSingleClick "[_pos select 0, _pos select 1, 8] execVM 'scripts\setup\placement2.sqf'; True";