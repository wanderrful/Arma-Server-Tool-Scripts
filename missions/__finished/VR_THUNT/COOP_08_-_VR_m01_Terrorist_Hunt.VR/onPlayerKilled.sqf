//context: client-side
params ["_oldUnit", "_killer", "_respawnMode", "_respawnDelay"];

if (isPlayer _killer) then { setPlayerRespawnTime 5; };

setPlayerRespawnTime 99999;

_soundList = ["Gottem", "Airhorn", "ATeam", "Airwolf"];
playSound ( _soundList select (floor random count _soundList) );

["Initialize", [player, [], false]] call BIS_fnc_EGSpectator;