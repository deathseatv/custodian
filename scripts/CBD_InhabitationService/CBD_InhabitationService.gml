/// Bundle D - Hub & Character Lifecycle
/// Inhabit/uninhabit flow (control ownership).

function InhabitationService(_world, _navigation, _lifecycle, _ui) constructor {
    world = _world;
    nav = _navigation;
    lifecycle = _lifecycle;
    ui = _ui;

    canInhabit = function(_characterId) {
        if (is_undefined(lifecycle)) return false;
        var st = lifecycle.getState(_characterId);
        return (st == global.CharacterLifeState.INACTIVE) || (st == global.CharacterLifeState.ACTIVE);
    };

    requestInhabit = function(_characterId) {
        if (!canInhabit(_characterId)) {
            if (!is_undefined(ui)) ui.showError("Cannot inhabit this character.");
            return false;
        }
        if (!is_undefined(ui)) ui.showInhabitPrompt(_characterId);
        return true;
    };

    confirmInhabit = function(_characterId) {
        if (is_undefined(world) || is_undefined(world.activeContext)) return false;
        if (!canInhabit(_characterId)) return false;

        world.activeContext.inhabitedCharacterId = string(_characterId);
        if (!is_undefined(nav)) nav.setCharacterControlled(_characterId);
        if (!is_undefined(lifecycle)) lifecycle.setState(_characterId, global.CharacterLifeState.ACTIVE);
        return true;
    };

    uninhabit = function() {
        if (is_undefined(world) || is_undefined(world.activeContext)) return false;
        world.activeContext.inhabitedCharacterId = undefined;
        if (!is_undefined(nav)) nav.setWispControlled();
        return true;
    };
}
