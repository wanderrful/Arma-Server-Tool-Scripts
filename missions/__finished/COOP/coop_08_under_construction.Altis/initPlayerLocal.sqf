params ["_unit", "_didJIP"];

sxf_fnc_onLoop =
{
	_message = format["<br/><t size='1.5'><t align='left'>Remaining enemies:</t><t align='right' color='#FFA500'>%1</t></t><br/> ", blufor countSide allUnits];
	hint parseText _message;
};

sxf_fnc_deployToInsertionZone = 
{
	params ["_whichSpawnZone"];
	_tempPos = [0,0,0];
	switch (_whichSpawnZone) do
	{
		case 1: //outside insertion zone
		{
			_tempPos = getMarkerPos "player-spawn-1";
			player setDir (markerDir "player-spawn-1");
		};
		case 2: 	//rooftop insertion zone
		{
			_tempPos = getMarkerPos "player-spawn-2";
			_tempPos set [2,16.1]; //the Z value of the rooftop
			player setDir (markerDir "player-spawn-2")
		};
	};
	player allowDamage false;
	player setPosATL _tempPos;
	player allowDamage true;
};

//whiteboard actions to deploy the players to the insertion zone
whiteBoard addAction 
[
	"Deploy to the OUTSIDE Insertion Zone",
	{
		[1] spawn sxf_fnc_deployToInsertionZone;
	}
];
whiteBoard addAction 
[
	"Deploy to the ROOFTOP Insertion Zone",
	{
		[2] spawn sxf_fnc_deployToInsertionZone;
	}
];


_unit addEventHandler	//to automatically give the player magazines of his or her weapon choice.
[
	"Take",
	{
		params ["_unit", "_container", "_item"];
		_allowedWeapons = ["hgun_PDW2000_F", "SMG_02_F", "arifle_Katiba_F", "arifle_MX_F", "srifle_EBR_F", "LMG_Mk200_F"];
		if (_item in _allowedWeapons) then
		{
			{
				player removeMagazines _x;
			} forEach (magazines player);
			player removeWeapon (currentWeapon player);
			[player, _item, 7] call BIS_fnc_addWeapon;
		};
		
	}
];

removeAllWeapons _unit;
removeUniform _unit;
_unit unlinkItem "NVGoggles_INDEP";
_unit forceAddUniform "U_IG_leader";

_unit addItem "FirstAidKit";_unit addItem "FirstAidKit";_unit addItem "FirstAidKit";_unit addItem "FirstAidKit";_unit addItem "FirstAidKit";

[_unit, "hgun_rook40_F", 5] call BIS_fnc_addWeapon;