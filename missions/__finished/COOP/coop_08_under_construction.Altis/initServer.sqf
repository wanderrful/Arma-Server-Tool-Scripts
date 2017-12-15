missionComplete = false; publicVariable "missionComplete";
//missionFailed isn't necessary anymore because it will automatically end when all players are dead due to the new in-game editor mission settings

whiteBoard setObjectTextureGlobal [0, "images\whiteBoard.jpg"];

_enemySide = blufor;	//if I ever try to copy-paste this mission to another thing and use a different side... let's do it this way so I can just edit one variable.
enemyUnitArray = [];
{
	if (side _x == _enemySide) then
	{
		enemyUnitArray pushBack _x;
		
		removeAllWeapons _x;
		removeAllAssignedItems _x;
		
		[_x, "arifle_TRG20_F", 5] call BIS_fnc_addWeapon;
		
		_x disableAI "COVER";
		_x disableAI "TARGET";
		
		_x setBehaviour "AWARE";
		_x setCombatMode "RED";
		
		_x addEventHandler
		[
			"Killed",
			{
				deleteVehicle _x;
			}
		];
	};
} forEach allUnits;