params ["_unit", "_didJIP"];

if (_didJIP) exitWith { 
	_unit setDamage 1;
	"The game says that you joined after the race actually started, so we had to change you into a spectator.  Sorry!" remoteExec ["hint", _unit];
};



_color = "#(argb,8,8,3)color(0.3,0.4,0.7,0.9,co)";	//baby blue as the default, error color
switch (vehicleVarName _unit) do
{
	case "p_1": {_color = "#(argb,8,8,3)color(1,0,0,0.1,co)";}; 				//red
	case "p_2": {_color = "#(argb,8,8,3)color(0.0,0.3,1,0.5,co)";}; 			//blue
	case "p_3": {_color = "#(argb,8,8,3)color(0.1,1,1,0.15,co)";}; 			//teal
	case "p_4": {_color = "#(argb,8,8,3)color(0.7,0.1,0.9,0.07,co)";}; 		//purple
	case "p_5": {_color = "#(argb,8,8,3)color(0.9,0.5,0.05,0.2,co)";}; 		//orange
	case "p_6": {_color = "#(argb,8,8,3)color(0,1,0,0.07,co)";}; 				//green
	case "p_7": {_color = "#(argb,8,8,3)color(1,1,1,0.3,co)";}; 				//white
	case "p_8": {_color = "#(argb,8,8,3)color(1,1,0,0.25,co)";}; 				//yellow
	case "p_9": {_color = "#(argb,8,8,3)color(0.3,0.4,0.7,0.9,co)";}; 			//baby blue
	case "p_10": {_color = "#(argb,8,8,3)color(1,0.318,0.89,1,co)";}; 			//pink
	case "p_11": {_color = "#(argb,8,8,3)color(0.596,0.325,0,1,co)";}; 		//brown
	case "p_12": {_color = "#(argb,8,8,3)color(0.471,0.471,0.471,1,co)";}; 		//gray
};

[_unit, [0, _color]] remoteExec ["setObjectTextureGlobal", _unit];					//camo



(parseText format ["<br/><t size='1.5' color='#E28014' align='center'>Race: Negades Stadium</t><br/>by sixtyfour<br/><br/><t align='left'>This is a proof of concept that I made because I wanted to play custom race maps but unfortunately the built-in bohemia thing was way too complex to figure out how to use. So I made my own system.<br/><br/>To do:<br/>- implement time tracking for each player<br/>- make the server display a list of checkpoint times both to the player and to everyone on the server during the race<br/>- display a summary when all players have finished the race<br/>- allow players to restart the race over again via a voting prompt dialog<br/>- make the bottom right control panel display useful information that live updates throughout the race.</t><br/><br/><br/><br/><t size='1.3' color='#E28014'>The countdown to start will begin in 10 seconds!</t><br/><br/><br/><br/>", nil]) remoteExec ["hint", _unit];