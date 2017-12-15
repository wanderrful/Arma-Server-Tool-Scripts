_unit 	= 	_this select 0;
_didJIP	=	_this select 1;

_unit setVariable ["unit_class", "rifleman", true];	//everybody should be a rifleman at the start of the mission!

_unit addEventHandler
[	//this event handler will take care of switching between classes for the player
	"Take",
	{
		params ["_thisUnit", "_container", "_item"];
		
		if (side _thisUnit != civilian) then	//don't let civilians change classes
		{
			switch (_item) do
			{
				case "B_AssaultPack_khk": 		{ [_thisUnit, "rifleman"] spawn sxf_fnc_switchLoadout; };		//Rifleman class
				case "B_FieldPack_cbr": 		{ [_thisUnit, "medic"] spawn sxf_fnc_switchLoadout; };		//Medic class
			};
		};
	}
];

sxf_fnc_switchLoadout =
{
	params ["_theUnit", "_toClass"];
	
	_fromClass = _theUnit getVariable ["unit_class", ""];
	if (_fromClass == "") exitWith {hint "ERROR (sxf_fnc_switchLoadout): _theUnit does not have a unit_class variable!"};
	
	//unequip current loadout
	removeAllWeapons _theUnit;
	removeAllItems _theUnit;
	removeHeadgear _theUnit;
	removeAllAssignedItems _theUnit;
	removeAllContainers _theUnit;
	removeGoggles _theUnit;
	removeBackpackGlobal _theUnit;
	
	
	
	switch (_toClass) do
	{	//equip the appropriate loadout
		case "rifleman": 
		{
			if (side _theUnit == blufor) then
			{
				_theUnit addHeadgear "H_HelmetB";
				_theUnit addVest "V_PlateCarrier1_rgr";
				
				if (_theUnit canAddItemToVest "HandGrenade") then { _theUnit addItemToVest "HandGrenade"; };
				if (_theUnit canAddItemToVest "SmokeShell") then { _theUnit addItemToVest "SmokeShell"; };
				if (_theUnit canAddItemToVest "FirstAidKit") then 
				{
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
				};
				
				_theUnit forceAddUniform "U_B_CombatUniform_mcam_tshirt";
				[_theUnit, "arifle_MX_ACO_pointer_F", 5] call BIS_fnc_addWeapon;
			};
			if (side _theUnit == opfor) then
			{
				_theUnit addHeadgear "H_HelmetO_ocamo";
				_theUnit addVest "V_HarnessO_brn";
				
				if (_theUnit canAddItemToVest "HandGrenade") then { _theUnit addItemToVest "HandGrenade"; };
				if (_theUnit canAddItemToVest "SmokeShell") then { _theUnit addItemToVest "SmokeShell"; };
				if (_theUnit canAddItemToVest "FirstAidKit") then 
				{
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
				};
				
				_theUnit forceAddUniform "U_O_CombatUniform_ocamo";
				[_theUnit, "arifle_Katiba_ACO_pointer_F", 5] call BIS_fnc_addWeapon;

			};
			if (side _theUnit == independent) then
			{
				_theUnit addHeadgear "H_HelmetIA";
				_theUnit addVest "V_PlateCarrierIA1_dgtl";
				
				if (_theUnit canAddItemToVest "HandGrenade") then { _theUnit addItemToVest "HandGrenade"; };
				if (_theUnit canAddItemToVest "SmokeShell") then { _theUnit addItemToVest "SmokeShell"; };
				if (_theUnit canAddItemToVest "FirstAidKit") then 
				{
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
				};
				
				_theUnit forceAddUniform "U_I_CombatUniform";
				[_theUnit, "arifle_Mk20_ACO_pointer_F", 5] call BIS_fnc_addWeapon;
				
			};
		};
		
		case "medic":
		{
			if (side _theUnit == blufor) then
			{
				_theUnit addHeadgear "H_HelmetB";
				_theUnit addVest "V_PlateCarrierSpec_rgr";
				
				if (_theUnit canAddItemToVest "SmokeShell") then { _theUnit addItemToVest "SmokeShell"; _theUnit addItemToVest "SmokeShell"; _theUnit addItemToVest "SmokeShellRed"; _theUnit addItemToVest "SmokeShellRed"; };
				if (_theUnit canAddItemToVest "FirstAidKit") then 
				{
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
				};
				
				_theUnit forceAddUniform "U_B_CombatUniform_mcam_tshirt";
				[_theUnit, "arifle_MX_ACO_pointer_F", 3] call BIS_fnc_addWeapon;
			};
			if (side _theUnit == opfor) then
			{
				_theUnit addHeadgear "H_HelmetO_ocamo";
				_theUnit addVest "V_TacVest_khk";
				
				if (_theUnit canAddItemToVest "SmokeShell") then { _theUnit addItemToVest "SmokeShell"; _theUnit addItemToVest "SmokeShell"; _theUnit addItemToVest "SmokeShellRed"; _theUnit addItemToVest "SmokeShellRed"; };
				if (_theUnit canAddItemToVest "FirstAidKit") then 
				{
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
				};
				
				_theUnit forceAddUniform "U_O_CombatUniform_ocamo";
				[_theUnit, "arifle_Katiba_pointer_F", 3] call BIS_fnc_addWeapon;
			};
			if (side _theUnit == independent) then
			{
				_theUnit addHeadgear "H_HelmetIA";
				_theUnit addVest "V_PlateCarrierIA2_dgtl";
				
				if (_theUnit canAddItemToVest "SmokeShell") then { _theUnit addItemToVest "SmokeShell"; _theUnit addItemToVest "SmokeShell"; _theUnit addItemToVest "SmokeShellRed"; _theUnit addItemToVest "SmokeShellRed"; };
				if (_theUnit canAddItemToVest "FirstAidKit") then 
				{
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
					_theUnit addItemToVest "FirstAidKit";
				};
				
				_theUnit forceAddUniform "U_I_CombatUniform_shortsleeve";
				[_theUnit, "arifle_Mk20_ACO_pointer_F", 3] call BIS_fnc_addWeapon;
			};
		};
	};
	
	//add universal items that everyone has
	_theUnit linkItem "ItemMap";
	_theUnit linkItem "ItemCompass";
	_theUnit linkItem "ItemWatch";
	_theUnit linkItem "itemRadio";
	
	//Drop a backpack of the player's old class at his or her feet
	_backpackToDrop = "";
	switch (_fromClass) do
	{
			case "rifleman":				{ _backpackToDrop = "B_AssaultPack_khk"; };
			case "medic":					{ _backpackToDrop = "B_FieldPack_cbr"; };
			default						{ hint "ERROR (sxf_fnc_switchLoadout): unable to drop backpack due to invalid _fromClass variable!"; };
	};
	
	if (_backpackToDrop != "") then 
	{
		createVehicle [_backpackToDrop, getPosATL _theUnit, [], 0, "CAN_COLLIDE"];		//for some reason backpacks don't like dropping exactly at your feet... wtf?
	};
	
	_theUnit setVariable ["unit_class", _toClass, true];

	systemChat format["You are now a %1 class.", _toClass];
};