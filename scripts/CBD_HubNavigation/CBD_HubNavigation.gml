/// Bundle D - Hub & Character Lifecycle
/// Tracks who currently owns control while in the hub.

function HubNavigation() constructor {
    if (is_undefined(global.HubControlMode)) {
        global.HubControlMode = { Wisp: 0, Character: 1 };
    }
    controlMode = global.HubControlMode.Wisp;
    controlledCharacterId = undefined;
    controlLocked = false;

    isControlLocked = function() { return controlLocked; };

    lockControl = function() { controlLocked = true; };
    unlockControl = function() { controlLocked = false; };

    setWispControlled = function() {
        if (controlLocked) return false;
        controlMode = global.HubControlMode.Wisp;
        controlledCharacterId = undefined;
        return true;
    };

    setCharacterControlled = function(_characterId) {
        if (controlLocked) return false;
        controlMode = global.HubControlMode.Character;
        controlledCharacterId = string(_characterId);
        return true;
    };
}
