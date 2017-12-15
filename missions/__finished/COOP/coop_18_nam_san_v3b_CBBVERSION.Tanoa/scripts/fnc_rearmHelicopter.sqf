//only two arguments: the helicopter in question and the time it takes to rearm
//just rearms the helicopter over the given number of seconds

params["_one", "_two", "_three"];

_helicopter = _this select 0;
_totalTime = _this select 1;

if (!isNil "_three") then {
	_helicopter = _this select 3 select 0;
	_totalTime = _this select 3 select 1;
};


cl_servicing = true;
vehicle player engineOn false;
_currentTime = _totalTime;
if (_currentTime != 0) then
{
	while {_currentTime > 0} do
	{
		_currentTime = _currentTime - 1;
		_percentage = floor ( ( 1 - (_currentTime/_totalTime) ) * 100 );
		switch (_currentTime % 3) do
		{
			case 0: {hint parseText format["<t align='left'>( %1 ) Rearming..</t>", str _percentage + "%"];};
			case 1: {hint parseText format["<t align='left'>( %1 ) Rearming...</t>", str _percentage + "%"];};
			case 2: {hint parseText format["<t align='left'>( %1 ) Rearming....</t>", str _percentage + "%"];};
		};
		if (isEngineOn vehicle player) exitWith
		{
			//abort rearm!
			hint "Helicopter rearming has been aborted due to the engine being activated before repairs were complete.";
		};
		sleep 1;
	};
	hint "Helicopter has been fully rearmed!";
};



//remove all weapons from the helicopter
{
	_helicopter removeWeaponTurret [_x, [-1]];
} forEach ( _helicopter weaponsTurret [-1] );
{
	_helicopter removeMagazineTurret [_x, [-1]];
} forEach ( _helicopter magazinesTurret [-1] );

sleep _totalTime;

//add back all the relevant helicopter stuff
_helicopter addWeaponTurret ["LMG_Minigun_heli", [-1]];
_helicopter addMagazineTurret ["500Rnd_65x39_Belt", [-1]];
vehicle player engineOn true;
cl_servicing = false;