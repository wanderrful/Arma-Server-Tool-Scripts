params ["_unit", "_didJIP"];

//*** Define the initial settings (CLIENTSIDE context)
enableSentences false;

if (count call BIS_fnc_listPlayers <= 1) then {
	player allowDamage false;
	OnMapSingleClick { player setPos _pos; };
};
[	//turn on the vanilla group management system (CLIENTSIDE)
	"InitializePlayer",
	[
		_unit
	]
] call BIS_fnc_dynamicGroups;



//*** Define the mission briefing information for the players' map menu
//I am using player here because for some reason it doesn't work consistently when I use _unit instead. I'll never understand why...
player createDiaryRecord ["Diary", ["Situation","<font color='#0060CD'>BLUFOR</font> players are equipped with silenced pistols and night vision goggles.<br/><br/><font color='#B22222'>OPFOR</font> players are equipped with GL Katiba rifles, a few HE GL rounds, and lots of flares."]];
player createDiaryRecord ["Diary", ["Mission","<font color='#0060CD'>BLUFOR</font> players must destroy 2 weapon caches in order to win or eliminate all <font color='#B22222'>OPFOR</font> players.<br/><br/><font color='#B22222'>OPFOR</font> players must defend until the mission timer has elapsed or eliminate all <font color='#0060CD'>BLUFOR</font> players."]];
player createDiaryRecord ["Diary", ["Intel","<font color='#0060CD'>BLUFOR</font> players can choose to retrieve a 9mm SMG from a hidden weapon stash somewhere in the base.  There are 2 weapon stashes in 4 possible locations.  The locations are marked on the map of each <font color='#0060CD'>BLUFOR</font> player.<br/><br/><font color='#0060CD'>BLUFOR</font> players are prohibited from picking up the <font color='#B22222'>OPFOR</font> Katiba rifles."]];



//*** Go straight to spectator if this player is a JIP
if (_didJIP) exitWith {
	if (! (side _unit isEqualTo "LOGIC") ) then { _unit setDamage 1; };
};



//*** Setup the markers and tasks depending on the player's team
switch (side _unit) do
{
	case blufor: 
	{	
		_task = player createSimpleTask ["Destroy two of the five caches!"];
		_task setSimpleTaskDescription ["In order to win, you must destroy two of the five weapon caches located in the base before the mission time runs out.  Their general locations are marked on your map via red, hashed circles.  They can be destroyed either by shooting it a bunch of times or with the demolition charge in your vest.", "Destroy two of the five caches", "DESTROY"];
		_task = player createSimpleTask ["Kill all OPFOR (optional)"];
		_task setSimpleTaskDescription ["The other possible way to win in this mission is to eliminate all OPFOR players.", "Kill all OPFOR (optional)", "KILL"];
		
		_unit addEventHandler
		[	//this event handler will take care of switching between classes for the player
			"Take",
			{
				params ["_thisUnit", "_container", "_item"];
				
				if (_item == "arifle_Katiba_GL_F") then 
				{
					_thisUnit removeWeaponGlobal (primaryWeapon _thisUnit);
					playSound "FD_Start_F";
					hint parseText "<br/><br/><t size='1.5' align='center' font='EtelkaNarrowMediumPro'><t color='#0060CD'>BLUFOR</t> players are prohibited from acquiring <t color='#B22222'>OPFOR</t> rifles for game balance reasons.</t><br/><br/><t align='left'>If you really need another weapon, you can take one from a weapon stash, marked on your map with a blue flag!</t>";
				};
			}
		];
	};
	
	case opfor: 
	{
		_task = player createSimpleTask ["Defend the five caches"];
		_task setSimpleTaskDescription ["In order to win, you must prevent the BLUFOR from destroying two of your five caches until the time runs out.  The location of each of the five caches are clearly marked on your map with a red flag", "Defend the five caches!", "KILL"];
		_task = player createSimpleTask ["Kill all BLUFOR (optional)"];
		_task setSimpleTaskDescription ["The other possible way to win in this mission is to eliminate all BLUFOR players.", "Kill all BLUFOR", "KILL"];
		
		//IDEA:	use createVehicleLocal to have a spotlight whenever the player activates the weapon flashlight??  is that even possible?
		
		_unit addEventHandler
		[	//this event handler will take care of switching between classes for the player
			"Take",
			{
				params ["_thisUnit", "_container", "_item"];
				
				if ( (_item splitString "_" select 1) isEqualTo "NVGoggles") then 
				{
					_thisUnit removeWeaponGlobal (primaryWeapon _thisUnit);
					playSound "FD_Start_F";
					hint parseText "<br/><br/><t size='1.5' align='center' font='EtelkaNarrowMediumPro'><t color='#B22222'>OPFOR</t> players are prohibited from acquiring <t color='#0060CD'>BLUFOR</t> night vision goggles for game balance reasons.</t><br/><br/><t align='left'>If you really need better vision, you should use your GL flare grenades to light up the area!</t>";
				};
			}
		];
	};

};



_unit enableFatigue false;



//*** Initialize the countdown timer for all players (CLIENTSIDE)
waitUntil {!isNil "currentTime"};
[] spawn
{
	while { (currentTime > 0) } do
	{
		//hint str currentTime;
		[
			str floor (currentTime/60) + "m" + str (currentTime % 60) + "s",
			safezoneX + 0.00 * safezoneW,	//x
			safezoneY + 0.85 * safezoneH,	//y
			0,		//duration
			0,
			0,
			9999		//rsc Layer
		] call BIS_fnc_dynamicText;
	};
	
	playSound "FD_Start_F";
	hint parseText "<t color='#0060CD'>BLUFOR</t> were not able to destroy two caches before the mission time ran out!<br/><br/><t color='#B22222'>OPFOR</t> wins!";
};
