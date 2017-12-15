/*
	Assumed file path:	mission-folder\tagus\fnc_whiteListArsenal.sqf
	
	If you put the script file elsewhere, make sure you reference it correctly! 
	I spent 3 hours while working on this pulling my hair out because I wrote / instead of \ when calling the execVM.
	I hate everything right now.
	
	Syntax:
	[object, boolean] execVM "tagus\fnc_whiteListTheArsenal.sqf";
	
	OR
	
	tagus_fnc_whiteListTheArsenal = compileFinal preprocessFile "tagus\fnc_whiteListTheArsenal.sqf";
		... and then you can call it on the fly whenever you want (locality permitting) like so:
	
	[object, boolean] call tagus_fnc_whiteListTheArsenal;
	
	Arguments:
		0:	The object you want people to look at and use to manually open the Arsenal interface (e.g. ammobox, player)
		1:	(optional) Set it to false unless the player is the 'object' and you want the Arsenal interface to open immediately after running the script. (Default: false)
		
	Description:
		When the boolean is set to false, this script will make a normal white-listed Virtual Arsenal ammobox that you can walk up to and use the action menu on.
		When the boolean is set to true, this script will immediately open up the Virtual Arsenal [hopefully on a player] with the same white-listed content as above.
		
		If you run this script at the start of the mission with [player, true] as the arguments (please do it locally to the player!), you can have the 
		
~/u/tagus, 29 Oct 2014
 */
private ["_ammoBox", "_openImmediatelyAfter", "_backpacks", "_magazines", "_weapons", "_items", "_actionArsenal"];

_ammoBox				= [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_openImmediatelyAfter	= [_this, 1, false, [false]] call BIS_fnc_param;

if (_ammoBox isEqualTo objNull) exitWith { ["ERROR! Invalid object to give the Arsenal function to!"] call BIS_fnc_error; };

if (!_openImmediatelyAfter) then //if it's a normal crate...
{
	["AmmoboxInit", [_ammoBox, false, {true}]] spawn BIS_fnc_arsenal;
};

_backpacks = //put backpacks in here
[
	"B_Parachute",
	"B_FieldPack_blk",
	"B_OutdoorPack_blk",
	"B_TacticalPack_blk"
];
_magazines = //put anything for which you'd normally use "addMagazines" in here
[
	"30Rnd_45ACP_Mag_SMG_01",
	"30Rnd_45ACP_Mag_SMG_01_tracer_green",
	
	"30Rnd_9x21_Mag",
	"11Rnd_45ACP_Mag",
	"16Rnd_9x21_Mag",
	
	"30Rnd_556x45_Stanag",
	"30Rnd_556x45_Stanag_Tracer_Red",
	"30Rnd_556x45_Stanag_Tracer_Green",
	"30Rnd_556x45_Stanag_Tracer_Yellow",		
	
	"30Rnd_65x39_caseless_mag",
	"30Rnd_65x39_caseless_mag_Tracer",
	
	"100Rnd_65x39_caseless_mag",
	"100Rnd_65x39_caseless_mag_Tracer",
	"200Rnd_65x39_cased_Box",
	"200Rnd_65x39_cased_Box_Tracer",
	
	"20Rnd_762x51_Mag",
	"5Rnd_127x108_Mag",
	"7Rnd_408_Mag",
	"10Rnd_762x51_Mag",
	
	"1Rnd_HE_Grenade_shell",

	"NLAW_F",
	"Titan_AA",
	"Titan_AT",

	"Laserbatteries",
	
	"SmokeShell",
	"SmokeShellBlue",
	"SmokeShellYellow",
	"SmokeShellGreen",
	"SmokeShellOrange",
	"SmokeShellPurple",
	"SmokeShellRed",

	"HandGrenade",
	"MiniGrenade",
	"B_IR_Grenade",

	"1Rnd_Smoke_Grenade_shell",
	"1Rnd_SmokeBlue_Grenade_shell",
	"1Rnd_SmokeGreen_Grenade_shell",
	"1Rnd_SmokeOrange_Grenade_shell",
	"1Rnd_SmokePurple_Grenade_shell",
	"1Rnd_SmokeRed_Grenade_shell",
	"1Rnd_SmokeYellow_Grenade_shell",

	"3Rnd_UGL_FlareCIR_F",
	"3Rnd_UGL_FlareGreen_F",
	"3Rnd_UGL_FlareRed_F",
	"3Rnd_UGL_FlareWhite_F",

	"UGL_FlareCIR_F",
	"UGL_FlareGreen_F",
	"UGL_FlareRed_F",
	"UGL_FlareWhite_F",
	
	"APERSBoundingMine_Range_Mag",
	"APERSMine_Range_Mag",
	"APERSTripMine_Wire_Mag",
	"ATMine_Range_Mag",
	"ClaymoreDirectionalMine_Remote_Mag",
	"SLAMDirectionalMine_Wire_Mag",
	"DemoCharge_Remote_Mag",
	"SatchelCharge_Remote_Mag"
];
_weapons = //put guns and launchers in here
[
	//--- rifles 
	"arifle_MX_Black_F",
	"arifle_MXC_Black_F",
	"arifle_MXM_Black_F",
	"arifle_Mk20_F",
	"arifle_TRG21_F",
	//--- GLs
	"arifle_MX_GL_Black_F",
	//--- mgs
	"LMG_Mk200_F",
	"arifle_MX_SW_Black_F",
	//--- snipers
	"srifle_EBR_F",
	"srifle_GM6_F",
	"srifle_LRR_F",
	"srifle_DMR_01_F",
	//--- smgs
	"SMG_01_F",
	"hgun_PDW2000_F",
	//--- launchers
	"launch_B_Titan_F",
	"launch_B_Titan_short_F",
	"launch_NLAW_F",
	//--- pistols
	"hgun_P07_F",
	"hgun_Pistol_heavy_01_F"
];
_items = //put everything else in here
[
	//--- stuff
	"ItemCompass",
	"ItemGPS",
	"ItemMap",
	"ItemWatch",
	"NVGoggles",
	"FirstAidKit",
	"Medikit",
	"ToolKit",
	
	//--- scopes
	"optic_Aco",
	"optic_Aco_smg",
	"optic_Holosight",
	"optic_Holosight_smg",
	"optic_Hamr",
	"optic_MRCO",
	"optic_Arco",
	"optic_MRD",
	"optic_Yorris",
	"optic_DMS",
	"optic_NVS",
	
	//--- suppressors
	"muzzle_snds_acp",
	"muzzle_snds_H",
	"muzzle_snds_L",
	"muzzle_snds_M",
	"muzzle_snds_H_SW",
	
	//--- attachments
	"acc_flashlight",
	"acc_pointer_IR",
	
	//--- uniforms
	"U_B_CombatUniform_mcam",
	"U_B_CombatUniform_mcam_tshirt",
	"U_B_CombatUniform_mcam_vest",
	"U_B_CTRG_1",
	"U_B_CTRG_2",
	"U_B_CTRG_3",
	
	//--- vests
	"V_BandollierB_blk",
	"V_Chestrig_blk",
	"V_PlateCarrier1_blk",
	"V_PlateCarrierH_CTRG",
	"V_PlateCarrierL_CTRG",
	"V_TacVestIR_blk",
	
	//--- berets
	
	//--- Helmets
	
	"H_HelmetB_camo",
	"H_HelmetB_light",
	"H_HelmetSpecB",
		
	"H_HelmetCrew_B",
	"H_PilotHelmetHeli_B",
	
	//--- caps n hats 
	"H_Cap_blk",
	"H_Cap_oli_hs",
	"H_Bandanna_khk_hs",
	"H_Booniehat_dirty",
	"H_Booniehat_khk_hs",


	//--- glasses
	"G_Spectacles",
	"G_Combat",
	"G_Lowprofile",
	"G_Shades_Black",
	"G_Tactical_Black",
	"G_Balaclava_lowprofile",
	"G_Balaclava_combat",
	"G_Bandanna_beast",
	"G_Bandanna_shades",
	
	//--- binoculars
	"Rangefinder",
	"Binocular",
	"Laserdesignator"
];

[_ammoBox, _backpacks] call BIS_fnc_addVirtualBackpackCargo;
[_ammoBox, _magazines] call BIS_fnc_addVirtualMagazineCargo;
[_ammoBox, _weapons] call BIS_fnc_addVirtualWeaponCargo;
[_ammoBox, _items] call BIS_fnc_addVirtualItemCargo;

if (_openImmediatelyAfter) exitWith //if it's a player and you want to open the arsenal immediately
{
	_actionArsenal = _ammoBox getVariable ["bis_fnc_arsenal_action", objNull];
	if (_actionArsenal isEqualTo objNull) exitWith
	{
		["ERROR! The Arsenal Action does not exist for the given object. Are you sure you didn't mess up the arguments and that the object is a player?"] call BIS_fnc_error;
		systemChat "error, line 250, fnc_whiteListTheArsenal.sqf";
	};
	_ammoBox action ["User", _ammoBox, _actionArsenal];
	_ammoBox removeAction _actionArsenal;
};