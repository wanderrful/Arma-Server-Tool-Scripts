params ["_unit", "_didJIP"];

sxf_fnc_onLoop =
{
	if (!roundInProgress) exitWith {hintSilent "";};
	_messageEnemiesRemaining = format["<br/><t size='1.5'><t align='left'>Remaining enemies:</t><t align='right' color='#FFA500'>%1</t></t><br/>", opfor countSide allUnits];
	
	_temp = currentMissionTimeRemaining;
	_minutes = floor (_temp / 60);
	_seconds = _temp % 60;
	
	_messageTimeRemaining = format["<br/><t size='1.25'><t align='left'>Time remaining:</t><t align='right' color='#FFA500'>%1m%2s</t></t><br/>", _minutes,_seconds];
	
	_messageCurrentRoundNumber = format["<br/><t size='1.25'><t align='left'>Number of attempts:</t><t align='right' color='#FFA500'>%1</t><br/>", currentRoundCount];
	
	hint parseText (_messageEnemiesRemaining + _messageTimeRemaining + _messageCurrentRoundNumber);
};

whiteBoard_1 addAction
[
	"Insert into the AO",
	{
		params ["_whiteBoard", "_unit", "_actionID", "_arguments"];
		
		[_unit] joinSilent activePlayerGroup; publicVariable "activePlayerGroup";
		
		if (!roundInProgress) then
		{	//signal to the server via in-editor trigger that sxf_fnc_prepareLevel needs to be called!
			if (!activateAO) then
			{
				activateAO = true; publicVariable "activateAO";
			};
			hint "Please wait for a moment while the server prepares the AO for the new round...";
			waitUntil {roundInProgress};
			hintSilent "";
		};
		_unit allowDamage false;
		_unit setPosATL ( getMarkerPos (playerSpawnMarkerList select 0) );
		_unit setDir ( markerDir (playerSpawnMarkerList select 0) );
		_unit allowDamage true;
		
	}
];

_unit addEventHandler	//to automatically give the player magazines of his or her weapon choice.
[
	"Take",
	{
		params ["_unit", "_container", "_item"];
		_allowedWeapons = ["hgun_PDW2000_F", "SMG_01_F", "SMG_02_F", "arifle_Katiba_F", "arifle_MX_F", "arifle_Mk20_plain_F", "srifle_EBR_F", "LMG_Mk200_F"];
		if (_item in _allowedWeapons) then
		{
			{
				player removeMagazines _x;
			} forEach (magazines player);
			player removeWeapon (currentWeapon player);
			[player, _item, 7] call BIS_fnc_addWeapon;
			reload player;
		};
		
		_temp = 0;
		switch (_item) do
		{
			case "arifle_Katiba_F": 
			{
				_temp = createVehicle ["Weapon_arifle_Katiba_F", [0,0,0], [], 0, "NONE"];
				_temp setPosATL [4025.5,6631.75,0.865];
			};
			case "arifle_MX_F":
			{
				_temp = createVehicle ["Weapon_arifle_MX_F", [0,0,0], [], 0, "NONE"];
				_temp setPosATL [4025.88,6631.88,0.865];
			};
			case "srifle_EBR_F": 
			{
				_temp = createVehicle ["Weapon_srifle_EBR_F", [0,0,0], [], 0, "NONE"];
				_temp setPosATL [4026.25,6632,0.865];
			};
			case "LMG_Mk200_F": 
			{
				_temp = createVehicle ["Weapon_LMG_Mk200_F", [0,0,0], [], 0, "NONE"];
				_temp setPosATL [4029.5,6633.5,0.865];
			};
			case "SMG_01_F": 
			{
				_temp = createVehicle ["Weapon_SMG_01_F", [0,0,0], [], 0, "NONE"];
				_temp setPosATL [4029.07,6633.29,0.865];
			};
			case "SMG_02_F": 
			{
				_temp = createVehicle ["Weapon_SMG_02_F", [0,0,0], [], 0, "NONE"];
				_temp setPosATL [4028.63,6633.25,0.865];
			};
			case "hgun_PDW2000_F": 
			{
				_temp = createVehicle ["Weapon_hgun_PDW2000_F", [0,0,0], [], 0, "NONE"];
				_temp setPosATL [4028.13,6633.13,0.865];
			};
			case "arifle_Mk20_plain_F": 
			{
				_temp = createVehicle ["Weapon_arifle_Mk20_plain_F", [0,0,0], [], 0, "NONE"];
				_temp setPosATL [4026.63,6632.38,0.865];
			};
		};
		if (! (_temp isEqualTo 0) ) then {
			_temp setDir 255;
		};
	}
];


//intro message at the start
[["MyVRStuff", "THUNT_IntroHint", "THUNT_IntroSubHint"]] call BIS_fnc_advHint;