//CONTEXT: global (multicast) and called from an in-editor trigger

{
	player addScore ( -1*(score player) );
} forEach (call BIS_fnc_listPlayers);

if (hasInterface) then 
{	//context: client-side
	hintSilent "";
	playSound "MissionFailureYourTeamWasWipedOut";
	[
		"<t size='2'><t color='#FFA500'>Mission Failure</t><br/>Your team was wiped out</t>",
		safezoneX + 0.27*safezoneW,
		safezoneY + 0.3*safezoneH,
		3,0,0,9995
	] spawn BIS_fnc_dynamicText;
	setPlayerRespawnTime 5; 
};

if (isServer) then 
{	//context: server-side

	//i need to find another way to do this, because this will create two more groups each round until it hits the limit of 144...
	deleteGroup activePlayerGroup;
	deleteGroup passivePlayerGroup;
	activePlayerGroup = (createGroup blufor); publicVariable "activePlayerGroup";
	passivePlayerGroup = (createGroup blufor); publicVariable "passivePlayerGroup";

	call sxf_fnc_dismantleLevel;
};