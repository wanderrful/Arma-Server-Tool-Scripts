//CONTEXT: CLIENTSIDE
_unit = _this select 0;

//["Terminate"] call BIS_fnc_EGSpectator;

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



//move player to the actual respawn location
_unit allowDamage false;
_unit setPosATL [11497, 14165, 4.2];
_unit allowDamage true;