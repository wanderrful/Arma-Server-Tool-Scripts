// Returns the Display Name of the given unit as a string
params ["_unit"];

_className = getText (configfile >> "CfgVehicles" >> (typeOf _unit) >> "displayName");



_className