/// Bundle D - Hub & Character Lifecycle
/// Applies life counter rules when a character dies.

function LifeSystem(_world, _lifecycle) constructor {
    world = _world;
    lifecycle = _lifecycle;
    registry = is_undefined(_world) ? undefined : _world.entityRegistry;

    _getEntity = function(_characterId) {
        if (is_undefined(registry)) return undefined;
        return registry.get(_characterId);
    };

    getLives = function(_characterId) {
        var e = _getEntity(_characterId);
        var lc = Life_GetComponent(e);
        if (is_undefined(lc)) return 0;
        return lc.data.livesRemaining;
    };

    isOutOfLives = function(_characterId) {
        return getLives(_characterId) <= 0;
    };

    consumeLifeOnDeath = function(_characterId) {
        var e = _getEntity(_characterId);
        var lc = Life_GetComponent(e);
        if (is_undefined(lc)) return false;
        lc.data.livesRemaining = max(0, lc.data.livesRemaining - 1);
        if (!is_undefined(lifecycle)) {
            if (lc.data.livesRemaining <= 0) lifecycle.setState(_characterId, global.CharacterLifeState.DEAD);
            else lifecycle.setState(_characterId, global.CharacterLifeState.INACTIVE);
        }
        return true;
    };
}
