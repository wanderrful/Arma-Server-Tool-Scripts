[ "InitializePlayer", [_unit] ] call BIS_fnc_dynamicGroups; // clientside initialization of the vanilla U-menu feature for group management 
enableSentences false;



// fixing the loadouts
player unlinkItem "ItemRadio";
//player unlinkItem (hmd player);



//*** The following functions are defined in the server-side mod's PreInit function, so we can assume they are defined here.
if (!isNil "SXF_Init_fnc_initSpecialHotkeys") then {
	// Add the F-key bindings that I like to use for my missions 
	call SXF_Init_fnc_initSpecialHotkeys;
};
if (!isNil "SXF_Utility_fnc_disableArsenalSavingLoading") then {
	// Disable the Saving and Loading buttons on the Arsenal so that people can't bypass the whitelisting
	call SXF_Utility_fnc_disableArsenalSavingLoading;
};



waitUntil { time > 0 };



player action ['SwitchWeapon', player, player, 99];



//*** intro hint briefing message
hint parseText (
	format["<br/><t size='1.5' color='#E28014' align='center'>%1</t>", briefingName] +
	"<br/>by sixtyfour<br/>" +
	"<br/><br/>" +
	"<br/>Mission Settings:" +
	format ["<br/><t align='left'>Toggle 'Status Loop' Key:</t><t align='right'>%1 or %2</t>", 
		keyImage 0x3b, 
		keyImage (actionKeys "User1" select 0)
	] +
	"<br/><t align='left'>Medical Preset:</t><t align='right'>Vanilla Revive</t>" +
	"<br/><t align='left'>Bleed Out Duration:</t><t align='right'>5 minutes</t>" +
	"<br/><t align='left'>Revive Duration:</t><t align='right'>20s (Medics, 8s)</t>" +
	"<br/><t align='left'>Who Can Revive?:</t><t align='right'>Anyone</t>" +
	"<br/><t align='left'>First-Aid Kit required?:</t><t align='right'>Yes</t>" +
	"<br/><t align='left'>Medkit required?</t><t align='right'>No</t>" +
	"<br/><t align='left'>On Death:</t><t align='right'>Switch to Spectator</t>" +
	"<br/><t align='left'>AI Difficulty level:</t><t align='right'>4 of 7</t>" + 
	"<br/><br/><br/>"
);