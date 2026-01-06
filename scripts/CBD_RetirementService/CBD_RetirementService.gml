/// Bundle D - Hub & Character Lifecycle
/// Retirement rules (character is no longer selectable).

function RetirementService(_world, _lifecycle, _lifeSystem, _inhabitation, _ui) constructor {
    world = _world;
    lifecycle = _lifecycle;
    lifeSystem = _lifeSystem;
    inhabitation = _inhabitation;
    ui = _ui;

    canRetire = function(_characterId) {
        if (is_undefined(lifecycle)) return false;
        var st = lifecycle.getState(_characterId);
        if (st == global.CharacterLifeState.RETIRED) return false;
        if (!is_undefined(lifeSystem)) {
            if (lifeSystem.isOutOfLives(_characterId)) return true;
        }
        return st == global.CharacterLifeState.DEAD;
    };

    retire = function(_characterId) {
        if (!canRetire(_characterId)) {
            if (!is_undefined(ui)) ui.showError("Cannot retire this character.");
            return false;
        }
        // Ensure not currently inhabited
        if (!is_undefined(world) && !is_undefined(world.activeContext)) {
            if (world.activeContext.inhabitedCharacterId == string(_characterId)) {
                if (!is_undefined(inhabitation)) inhabitation.uninhabit();
            }
        }
        if (!is_undefined(lifecycle)) lifecycle.setState(_characterId, global.CharacterLifeState.RETIRED);
        if (!is_undefined(ui)) ui.showRetirePrompt(_characterId);
        return true;
    };
}
