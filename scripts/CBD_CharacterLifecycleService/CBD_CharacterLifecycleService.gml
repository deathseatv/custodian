/// Bundle D - Hub & Character Lifecycle
/// Owns character creation and lifecycle state transitions.

function CharacterLifecycleService(_world) constructor {
    world = _world;
    registry = is_undefined(_world) ? undefined : _world.entityRegistry;

    _getCharacterEntity = function(_characterId) {
        if (is_undefined(registry)) return undefined;
        return registry.get(_characterId);
    };

    _getCharComp = function(_entity) {
        return Character_GetComponent(_entity);
    };


    createCharacter = function(_displayName, _portraitId, _weaponType, _maxLives) {
        if (is_undefined(world) || is_undefined(registry)) return undefined;
        var e = new Entity(undefined, "character");
        e.addComponent(CharacterComponent_Create(_displayName, _portraitId, _weaponType));
        e.addComponent(LifeComponent_Create(_maxLives));
        e.addComponent(HubPresenceComponent_Create(-1, ""));
        registry.add(e);
        if (!is_array(world.hub.entities)) world.hub.entities = [];
        array_push(world.hub.entities, e.id);
        setState(e.id, global.CharacterLifeState.INACTIVE);
        return e.id;
    };

    getState = function(_characterId) {
        var e = _getCharacterEntity(_characterId);
        var cc = _getCharComp(e);
        if (is_undefined(cc)) return global.CharacterLifeState.INACTIVE;
        if (is_undefined(cc.data.lifeState)) return global.CharacterLifeState.INACTIVE;
        return cc.data.lifeState;
    };

    setState = function(_characterId, _state) {
        var e = _getCharacterEntity(_characterId);
        var cc = _getCharComp(e);
        if (is_undefined(cc)) return false;
        cc.data.lifeState = _state;
        return true;
    };

    isPlayable = function(_characterId) {
        var st = getState(_characterId);
        return (st == global.CharacterLifeState.ACTIVE) || (st == global.CharacterLifeState.INACTIVE);
    };
}
