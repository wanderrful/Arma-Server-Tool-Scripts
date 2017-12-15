//context: server-side
params ["_unit", "_didJIP"];
_unit addEventHandler
[
	"Killed",
	{
		params ["_unit", "_killer"];
		
		deleteVehicle _unit;
	}
];