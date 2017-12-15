//ex: (vehicle player) spawn sxf_fnc_prepareAircraft;

//clear each jet's weapon loadout
_temp = _this;
{	
	if (_x != "CMFlareLauncher") then	//i don't know how to re-add this back into the chaff slot for some reason... :'c
	{
		_temp removeWeaponTurret [_x, [-1]]; 
	};
} forEach (_temp weaponsTurret [-1]);
{
	_temp removeMagazineTurret [_x, [-1]];
} forEach (_temp magazinesTurret [-1]);


//refit the aircraft with the loadout that we want it to have
_temp addWeaponTurret ["gatling_30mm", [-1]]; 
_temp addMagazineTurret ["250Rnd_30mm_APDS_shells", [-1]];
_temp addWeaponTurret ["missiles_ASRAAM", [-1]]; 
_temp addMagazineTurret ["2Rnd_AAA_missiles", [-1]];

//add the chaff back to the aircraft
//_temp addWeaponTurret ["CMFlareLauncher", [-1]];
_temp addMagazineTurret ["300Rnd_CMFlare_Chaff_Magazine", [-1]];

//reload ammo when depleted, after a brief period of time
_temp addEventHandler
[
	"Fired",
	{
		params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
		if ((vehicle _unit) magazineTurretAmmo [_magazine, [-1]] < 1) then
		{
			[_unit, _magazine] spawn
			{
				params ["_unit", "_magazine"];
				switch (_magazine) do
				{
					case "250Rnd_30mm_APDS_shells": 
					{
						["<t color='#FF1493' size = '.8' align='left'>Reloading guns (10s)...</t>",safezoneX + 0.2*safezoneW,safezoneY + 0.68*safezoneH,5,0,0.05,9995] spawn BIS_fnc_dynamicText;
						sleep 5;
						(vehicle _unit) removeMagazineTurret ["250Rnd_30mm_APDS_shells", [-1]];
						(vehicle _unit) addMagazineTurret ["250Rnd_30mm_APDS_shells", [-1]]; 
					};
					case "2Rnd_AAA_missiles": 
					{
						["<t color='#EE2C2C' size = '.8' align='left'>Reloading missiles (10s)...</t>",safezoneX + 0.2*safezoneW,safezoneY + 0.75*safezoneH,10,0,0.05,9996] spawn BIS_fnc_dynamicText;
						sleep 10;
						(vehicle _unit) removeMagazineTurret ["2Rnd_AAA_missiles", [-1]];
						(vehicle _unit) addMagazineTurret ["2Rnd_AAA_missiles", [-1]]; 
					};
					case "300Rnd_CMFlare_Chaff_Magazine":
					{
						["<t color='#CD2626' size = '.8' align='left'>Reloading chaff (10s)...</t>",safezoneX + 0.2*safezoneW,safezoneY + 0.85*safezoneH,5,0,0.05,9997] spawn BIS_fnc_dynamicText;
						sleep 5;
						(vehicle _unit) removeMagazineTurret ["300Rnd_CMFlare_Chaff_Magazine", [-1]];
						(vehicle _unit) addMagazineTurret ["300Rnd_CMFlare_Chaff_Magazine", [-1]]; 
					};
				};
				hint "";
			};
		};
	}
];