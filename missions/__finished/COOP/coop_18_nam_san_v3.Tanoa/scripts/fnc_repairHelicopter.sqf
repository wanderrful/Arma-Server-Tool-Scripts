//only two arguments: the helicopter in question and the time it takes to repair&refuel
//just repairs and refuels the helicopter over the given number of seconds
//note -- the refueling is only meant to allow for about 6 minutes of flight time

params["_one", "_two", "_three"];

_helicopter = _this select 0;
_totalTime = _this select 1;

if (!isNil "_three") then {
	_helicopter = _this select 3 select 0;
	_totalTime = _this select 3 select 1;
};



cl_servicing = true;
(vehicle player) engineOn false;
_currentTime = _totalTime;
if (_currentTime != 0) then
{
	while {_currentTime > 0} do
	{
		_currentTime = _currentTime - 1;
		_percentage = floor ( ( 1 - (_currentTime/_totalTime) ) * 100 );
		switch (_currentTime % 3) do
		{
			case 0: {hint parseText format["<t align='left'>( %1 ) Repairing and refueling..</t>", str _percentage + "%"];};
			case 1: {hint parseText format["<t align='left'>( %1 ) Repairing and refueling...</t>", str _percentage + "%"];};
			case 2: {hint parseText format["<t align='left'>( %1 ) Repairing and refueling....</t>", str _percentage + "%"];};
		};
		if (isEngineOn vehicle player) exitWith
		{
			//abort repair!
			hint "Helicopter repairing has been aborted due to the engine being activated before repairs were complete.";
		};
		sleep 1;
	};
	hint "Helicopter has been fully repaired and refueled for another 6 minutes!";
};


(vehicle player) setDamage 0;
(vehicle player) setFuel 0.06;
(vehicle player) engineOn true;
cl_servicing = false;