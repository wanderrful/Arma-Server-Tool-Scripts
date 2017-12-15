_pos = [_this select 0, _this select 1, _this select 2];
		
"town" setMarkerPos [_pos select 0, _pos select 1, 100];
"town" setMarkerShape "ICON";
"town" setMarkerType "b_hq";

hint format["Done"];
onMapSingleClick "";

sleep 0.5;
closedialog 0;
sleep 0.5;
hint format["Click on the position you would like the attacker to come from (1/4)."];
openMap [true, false];
onMapSingleClick "[_pos select 0, _pos select 1, 8] execVM 'scripts\setup\placement1.sqf'; True";