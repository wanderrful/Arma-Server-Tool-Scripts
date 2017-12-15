params ["_unit", "_didJIP"];
enableSaving [false, false];
enableSentences false;

cl_servicing = false; //used for helicopter repair & rearm

//detect whether we're using ACRE or TFR
_hasACRE = false;
if ( !(isNil "acre_api_fnc_isInitialized") ) then { //if using acre2
	_hasACRE = true;
};

//vietnam loadouts (apex and ace dependent)
loadout_vietnam_rifleman_ace 			= [["arifle_SPAR_01_blk_F","","","",["30Rnd_556x45_Stanag",30],[],""],[],["hgun_ACPC2_F","","","",["9Rnd_45ACP_Mag",8],[],""],["U_B_T_Soldier_F",[["ACE_fieldDressing",6],["ACE_morphine",3],["ACE_EarPlugs",1]]],["V_TacVest_oli",[["30Rnd_556x45_Stanag",7,30],["MiniGrenade",1,1],["SmokeShell",1,1],["9Rnd_45ACP_Mag",2,8],["DemoCharge_Remote_Mag",1,1]]],["B_Kitbag_rgr",[["30Rnd_556x45_Stanag",7,30],["DemoCharge_Remote_Mag",1,1]]],"H_Booniehat_oli","",[],["","","","ItemCompass","ItemWatch",""]];
loadout_vietnam_gun_1_ace 				= [["arifle_SPAR_01_blk_F","","","",["30Rnd_556x45_Stanag",30],[],""],[],["hgun_ACPC2_F","","","",["9Rnd_45ACP_Mag",8],[],""],["U_B_T_Soldier_AR_F",[["ACE_fieldDressing",6],["ACE_morphine",3],["ACE_EarPlugs",1]]],["V_BandollierB_oli",[["SmokeShell",1,1],["30Rnd_556x45_Stanag",5,30],["MiniGrenade",1,1]]],["RHS_DShkM_Gun_Bag",[]],"H_Booniehat_oli","",[],["","","","ItemCompass","ItemWatch",""]];
loadout_vietnam_gun_2_ace 				= [["arifle_SPAR_01_blk_F","","","",["30Rnd_556x45_Stanag",30],[],""],[],["hgun_ACPC2_F","","","",["9Rnd_45ACP_Mag",8],[],""],["U_B_T_Soldier_AR_F",[["ACE_fieldDressing",6],["ACE_morphine",3],["ACE_EarPlugs",1]]],["V_BandollierB_oli",[["SmokeShell",1,1],["30Rnd_556x45_Stanag",5,30],["MiniGrenade",1,1]]],["RHS_DShkM_TripodLow_Bag",[]],"H_Booniehat_oli","",[],["","","","ItemCompass","ItemWatch",""]];
loadout_vietnam_medic_ace 				= [["arifle_SPAR_01_blk_F","","","",["30Rnd_556x45_Stanag",30],[],""],[],[],["U_B_T_Soldier_F",[["ACE_EarPlugs",1],["ACE_fieldDressing",6]]],["V_BandollierB_oli",[["SmokeShell",4,1],["SmokeShellRed",4,1],["MiniGrenade",1,1],["30Rnd_556x45_Stanag",5,30]]],["B_FieldPack_oli",[["ACE_fieldDressing",20],["ACE_epinephrine",6],["ACE_morphine",14],["ACE_bloodIV_500",6]]],"H_Booniehat_oli","",[],["","","","ItemCompass","ItemWatch",""]];
loadout_vietnam_team_leader_ace 		= [["arifle_SPAR_01_blk_F","","","",["30Rnd_556x45_Stanag",30],[],""],[],[],["U_B_T_Soldier_F",[["ACE_fieldDressing",6],["ACE_EarPlugs",1],["ACE_MapTools",1],["SmokeShellBlue",3,1],["MiniGrenade",2,1]]],["V_Rangemaster_belt",[["30Rnd_556x45_Stanag",5,30]]],[],"H_Beret_02","",["Binocular","","","",[],[],""],["ItemMap","","","ItemCompass","ItemWatch",""]];
loadout_vietnam_officer_ace 			= [["arifle_SPAR_01_blk_F","","","",["30Rnd_556x45_Stanag",30],[],""],[],[],["U_B_T_Soldier_F",[["ACE_fieldDressing",6],["ACE_EarPlugs",1],["ACE_MapTools",1],["SmokeShellBlue",3,1],["MiniGrenade",2,1]]],["V_Rangemaster_belt",[["30Rnd_556x45_Stanag",5,30]]],[],"H_Beret_Colonel","",["Binocular","","","",[],[],""],["ItemMap","","","ItemCompass","ItemWatch",""]];

loadout_vietnam_radio_operator_ace_tfr 	= [["arifle_SPAR_01_blk_F","","","",["30Rnd_556x45_Stanag",30],[],""],[],["hgun_ACPC2_F","","","",["9Rnd_45ACP_Mag",8],[],""],["U_B_T_Soldier_F",[["ACE_fieldDressing",6],["ACE_EarPlugs",1]]],["V_BandollierB_khk",[["30Rnd_556x45_Stanag",5,30],["SmokeShellGreen",3,1],["SmokeShell",3,1]]],["tf_anprc155",[]],"H_Booniehat_khk_hs","",[],["","","","ItemCompass","ItemWatch",""]];
loadout_vietnam_radio_operator_ace_acre = [["arifle_SPAR_01_blk_F","","","",["30Rnd_556x45_Stanag",30],[],""],[],["hgun_ACPC2_F","","","",["9Rnd_45ACP_Mag",8],[],""],["U_B_T_Soldier_F",[["ACE_fieldDressing",6],["ACE_EarPlugs",1],["ACRE_PRC343_ID_1",1],["ACRE_PRC148_ID_2",1]]],["V_BandollierB_khk",[["30Rnd_556x45_Stanag",5,30],["SmokeShellGreen",3,1],["SmokeShell",3,1]]],[],"H_Booniehat_khk_hs","",[],["","","ItemRadioAcreFlagged","ItemCompass","Itemwatch",""]];

loadout_vietnam_pilot_ace				= [[],[],["hgun_ACPC2_F","","","",["9Rnd_45ACP_Mag",8],[],""],["U_B_HeliPilotCoveralls",[["ACE_fieldDressing",6],["ACE_EarPlugs",1],["ACE_MapTools",1]]],["V_Rangemaster_belt",[["9Rnd_45ACP_Mag",3,8],["SmokeShellBlue",3,1]]],[],"H_PilotHelmetHeli_B","",["Binocular","","","",[],[],""],["ItemMap","","","ItemCompass","ItemWatch",""]];
loadout_vietnam_pilot_ace_acre 			= [[],[],["hgun_ACPC2_F","","","",["9Rnd_45ACP_Mag",8],[],""],["U_B_HeliPilotCoveralls",[["ACE_fieldDressing",6],["ACE_EarPlugs",1],["ACE_MapTools",1],["ACRE_PRC148_ID_1",1]]],["V_Rangemaster_belt",[["9Rnd_45ACP_Mag",3,8],["SmokeShellBlue",3,1]]],[],"H_PilotHelmetHeli_B","",["Binocular","","","",[],[],""],["ItemMap","","ItemRadioAcreFlagged","ItemCompass","Itemwatch",""]];

loadout_vietnam_radio_operator_ace = loadout_vietnam_radio_operator_ace_tfr; //assume TFR in case of neither being the case
if (_hasACRE) then { 
	loadout_vietnam_radio_operator_ace = loadout_vietnam_radio_operator_ace_acre;
	loadout_vietnam_pilot_ace = loadout_vietnam_pilot_ace_acre;
};



_OfficerBriefing = "Commander, your radio operator will facilitate communication between the team leaders as well as with the helicopter pilots for this mission.  You have also been specially equipped with a map and binoculars.  It is advisable to find a safe, elevated position so that you can survey the battlefield and effectively direct your forces!<br/><br/><br/>Also, please note that you may have to coordinate a logistical run with one of your transport ships during the mission in order to resupply your forces in the field as they are carrying only moderate amounts of ammunition.  Supply crates can be found just outside your starting area.";
_RadioOpBriefing = "Radio Operator, make sure to communicate with your team leader so that you can relay messages between the different friendly units for this mission.<br/><br/><br/>(for command radio operator) You should use two radio channels for this mission: one for ground forces and one for air forces.  Make sure to switch to the appropriate channel so that you can handle communication effectively!";
_LeaderBriefing = "Team Leader, your radio man is equipped with the only means of communication between squads.  Make sure to keep the people in your squad together and organized by using direct voice communication.  As for yourself, you are equipped with binoculars and a map so that you can navigate through the mission per your commander's orders.";
_MedicBriefing = "Medic, you have been specially equipped with the bandages, morphine, epinepherine, etc that you will require for this mission.  You are the only Medic available to help your team, so please take care to stay safe from the action so that you can revive your teammates!<br/><br/><br/>This mission uses BASIC medical settings for ACE3. Instant death is DISABLED and the Bleedout Coefficient is 0.8.  There are no Medical Zones or Vehicles.";
_GunnerBriefing = "Gunner, you are equipped with one half of a .50cal HMG static gun.  Cooperate with your team's partner to setup and dismantle .50cal guns as necessary during the mission so that you can provide extra power to your team!";
_RiflemanBriefing = "Rifleman, you are carrying the most ammunition for your entire team!  Make sure that you try to share some with your teammates.  When you are low, remember to let your Team Leader know so that they can make arrangements for a logistics run with your transport pilots via the radio operator!";
_TransBriefing = "Transport pilot, you may be required by your commander during the mission to conduct a logistics run in order to resupply your teammates in the field.  There is a fenced off region of supply crates containing ammunition and medical equipment near your starting position.  Use your winch to sling load the necessary logistics equipment so that you can fly by and drop it off near your teammates' locations.  It will likely be far too dangerous to try and land during the fighting, especially considering how dense the jungle in the AO will be!<br/><br/>Your helicopter radio's channel 1 has automatically been tuned to 110 so that you can communicate with the command element's radio operator.";
_GunshipBriefing = "Gunship pilot,  it is vital that you escort the transport helicopters and keep them safe from enemy fire!  During the mission, you will likely have to answer calls for air support by spraying into the thick jungle as you will probably not be able to spot the enemy forces individually through the jungle canopy.  Make sure to confirm target locations over the vehicle radio before beginning your run!<br/><br/>Your helicopter radio's channel 1 has automatically been tuned to 110 so that you can communicate with the command element's radio operator.";

_personalizedBriefing = "ERROR: I FUCKED UP initPlayerLocal.sqf (CANNOT TELL WHICH UNIT YOU ARE)";

_playerObjectName = vehicleVarName _unit;
switch (_playerObjectName) do
{
	case "p_cmd_officer": 		{_unit setUnitLoadout loadout_vietnam_officer_ace; _personalizedBriefing = _OfficerBriefing;};
	
	case "p_cmd_radio": 		{_unit setUnitLoadout loadout_vietnam_radio_operator_ace; _personalizedBriefing = _RadioOpBriefing;};
	case "p_t1_radio": 		{_unit setUnitLoadout loadout_vietnam_radio_operator_ace; _personalizedBriefing = _RadioOpBriefing;};
	case "p_t2_radio": 		{_unit setUnitLoadout loadout_vietnam_radio_operator_ace; _personalizedBriefing = _RadioOpBriefing;};
	
	case "p_t1_leader": 		{_unit setUnitLoadout loadout_vietnam_team_leader_ace; _personalizedBriefing = _LeaderBriefing;};
	case "p_t2_leader": 		{_unit setUnitLoadout loadout_vietnam_team_leader_ace; _personalizedBriefing = _LeaderBriefing;};
	
	case "p_t1_medic": 		{_unit setUnitLoadout loadout_vietnam_medic_ace; _personalizedBriefing = _MedicBriefing;};
	case "p_t2_medic": 		{_unit setUnitLoadout loadout_vietnam_medic_ace; _personalizedBriefing = _MedicBriefing;};
	
	case "p_t1_gun_1": 		{_unit setUnitLoadout loadout_vietnam_gun_1_ace; _personalizedBriefing = _GunnerBriefing;};
	case "p_t2_gun_1": 		{_unit setUnitLoadout loadout_vietnam_gun_1_ace; _personalizedBriefing = _GunnerBriefing;};
	
	case "p_t1_gun_2": 		{_unit setUnitLoadout loadout_vietnam_gun_2_ace; _personalizedBriefing = _GunnerBriefing;};
	case "p_t2_gun_2": 		{_unit setUnitLoadout loadout_vietnam_gun_2_ace; _personalizedBriefing = _GunnerBriefing;};
	
	case "p_t1_rifle": 		{_unit setUnitLoadout loadout_vietnam_rifleman_ace; _personalizedBriefing = _RiflemanBriefing;};
	case "p_t2_rifle": 		{_unit setUnitLoadout loadout_vietnam_rifleman_ace; _personalizedBriefing = _RiflemanBriefing;};
	
	case "p_trans_1": 		{_unit setUnitLoadout loadout_vietnam_pilot_ace; _personalizedBriefing = _TransBriefing;};
	case "p_trans_2": 		{_unit setUnitLoadout loadout_vietnam_pilot_ace; _personalizedBriefing = _TransBriefing;};
	
	case "p_gun_1": 			{_unit setUnitLoadout loadout_vietnam_pilot_ace; _personalizedBriefing = _GunshipBriefing;};
	case "p_gun_2": 			{_unit setUnitLoadout loadout_vietnam_pilot_ace; _personalizedBriefing = _GunshipBriefing;};
};

//send personalized hint message here and log it to the mission briefing log
player createDiaryRecord ["Diary", ["** READ ME! **", _personalizedBriefing]];

player createDiaryRecord ["Diary", ["** MISSION FORMAT INFO **", "- this mission is very different from what you are used to.  i like to think of it as 'vietnam' rules for arma.<br/>- here are the main differences from what you guys are used to:<br/>     * everyone in the mission has a distinct role to play with a unique loadout<br/>     * only the leaders of each group (pilots also) have access to a map (everyone still has a compass and watch, though)<br/>     * each team has a radio operator who is the only one with access to radio communication (pilots have vehicle radios and there are no short-range radios)<br/>     * each team has a rifleman, who carries the majority of the ammunition for their team.  bother them if you're low on ammmo.<br/>     * each team has a medic, who is the only one to carry morphine etc etc<br/>     * each gunship has only a limited amount of gunfire because of budget cuts (read: game balance and fun) and they can be re-armed back at the staging area<br/>     * there is no instant death here, but bleeding out is possible albeit slowed a little bit for balance purposes.  so if your teammates die, you will have to loot their corpses for their important equipment.<br/>     * anyone can apply epinepherine and morphine, but the non-medic penalty is a lot greater than what you are used to<br/>     * your team is provided only with minimal supplies to complete the mission (due to budget cuts).  so when you are low on supplies, the transport pilots can sling load supply crates near your spawn location so that you can do a supply drop as they fly by over the jungle canopy.  call the commander and tell them to send supplies.<br/>      * helicopter pilots can land and repair their aircraft at marked locations on the map near the starting area, which takes one minute.  if you also want to re-arm your helicopter, then you have to wait for 5 minutes for balance reasons (makes air support more precious to use).<br/>     * if your helicopter is destroyed, you cannot replace it.<br/>     * when you inevtiably die in this mission, you will automatically go into spectator mode so that you can fly around and observe the mission while you wait for it to end (or for the admin to restart it for whatever reason)<br/>     * helicopter pilots are provided with only about 10 minutes worth of fuel (due to budget cuts) so that it's important to refuel often<br/><br/>- i should also let you guys know about the mission objectives:<br/>     * only when the POWs are either safely back at base or escorted to the designated escort zone on the map will the mission end in victory<br/>     * if a POW is killed, the mission will automatically end in failure and you will have to try again<br/>     * if both of the ground teams are killed (all of team one and all of team two), the mission will automatically end in failure and will have to try again"]];

player createDiaryRecord ["Diary", ["Primary Objectives", "Primary Objectives:<br/><br/>     * Liberate all three POWs from the Prison Camp<br/>     * Do not allow any POWs to be killed<br/>     * Escort all POWs to any of the two extraction zones"]];


//waitUntil {hasInterface _unit};	//player has now finished loading into the mission



//add special, class-specific actions
if (_playerObjectName in ["p_trans_1", "p_trans_2", "p_gun_1", "p_gun_2"]) then
{
	_unit addAction
	[
		"<t color='#eeee00'>* Repair and Refuel Helicopter</t>",
		"scripts\fnc_repairHelicopter.sqf", //run the aircraft repair script
		[vehicle player, 60], //parameters
		6,
		true,
		true,
		"",
		"!cl_servicing && {typeOf vehicle player in ['B_Heli_Light_01_armed_F', 'B_Heli_Light_01_F']} && {isTouchingGround (vehicle player)} && {(position vehicle player) inArea trg_helipad}",
		2.75,
		false
	];
	_unit addAction
	[
		"<t color='#ee0000'>* Rearm Helicopter</t>",
		"scripts\fnc_rearmHelicopter.sqf", //run the aircraft rearm script
		[vehicle player, 300], //parameters
		6,
		true,
		true,
		"",
		"!cl_servicing && {typeOf vehicle player == 'B_Heli_Light_01_armed_F'} && {isTouchingGround (vehicle player)} && {(position vehicle player) inArea trg_helipad}",
		2.75,
		false
	];
}
else
{	//player is not a pilot, so add an event handler preventing them from getting into a pilot or copilot seat!
	_unit addEventHandler
	[
		"GetInMan",
		{
			params ["_unit", "_position", "_vehicle", "_turret"];
			if (_position != "cargo") then
			{
				moveOut _unit;
			};
		}
	];
};

//remove mcc bullshit, if the mod is enabled
if ( (configfile >> "CfgMCCitemsActions") != configNull ) then { player removeAction 0; player removeAction 1; };


waitUntil {isPlayer player};

hint parseText ("(this message has been logged in your Briefing)<br/><t align='left' size='1.3'>" + _personalizedBriefing + "</t>");