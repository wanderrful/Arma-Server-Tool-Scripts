/// Remove everything that the given unit has equipped EXCEPT for their cosmetics (e.g. uniform, helmet, goggles).
// TODO: figure out where the backpack is supposed to go and include that so that it isn't removed automatically
params ["_unit"];

if (_unit isKindOf "Man") then {
	_unit setUnitLoadout [[],[],[],[(uniform _unit),[]],[(vest _unit),[]],[],(headgear _unit),(goggles _unit),[],["","","","","",""]];
};