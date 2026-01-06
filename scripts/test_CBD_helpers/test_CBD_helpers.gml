/// test_CBD_helpers.gml
/// Internal helpers for CBD test suites. Keep minimal and self-contained.

function _test_CBD_makeWorld() {
    var w = new WorldState();

    if (is_undefined(w.hub)) w.hub = new HubState();
    if (!is_array(w.hub.entities)) w.hub.entities = [];

    if (is_undefined(w.activeContext)) w.activeContext = new ActiveContext();
    if (is_undefined(w.activeContext.inHub)) w.activeContext.inHub = true;

    if (is_undefined(w.entityRegistry)) w.entityRegistry = new EntityRegistry();

    return w;
}

function _test_CBD_makeController() {
    var w = _test_CBD_makeWorld();
    var hc = new HubController(w);
    if (is_struct(hc) && variable_struct_exists(hc, "init")) hc.init(w);
    return { world: w, hub: hc };
}

/// Safely get the CharacterLifeState enum root (supports either name).
function _test_CBD_getLifeEnum() {
    if (variable_global_exists("CharacterLifeState")) return variable_global_get("CharacterLifeState");
    if (variable_global_exists("CBD_CharacterLifeState")) return variable_global_get("CBD_CharacterLifeState");
    return undefined;
}

/// Create and register a character entity with a deterministic id (avoids uuid_generate issues).
/// Returns { id, entity, lifecycle }.
function _test_CBD_createCharacter(_w, _char_id, _name, _portraitId, _weaponType, _maxLives) {
    var lifecycle = new CharacterLifecycleService(_w);

    var e = new Entity(string(_char_id), "character");

    var cChar = new CharacterComponent(_name, _portraitId, _weaponType);
    e.addComponent(cChar);

    var maxL = is_undefined(_maxLives) ? 3 : _maxLives;
    var cLife = new LifeComponent(maxL);
    e.addComponent(cLife);

    var cHub = new HubPresenceComponent(0, "husk_default");
    e.addComponent(cHub);

    if (is_struct(_w.entityRegistry) && variable_struct_exists(_w.entityRegistry, "add")) {
        _w.entityRegistry.add(e);
    }

    if (is_array(_w.hub.entities)) array_push(_w.hub.entities, e.id);

    var E = _test_CBD_getLifeEnum();
    if (!is_undefined(E) && variable_struct_exists(E, "INACTIVE")) {
        lifecycle.setState(e.id, E.INACTIVE);
    }

    return { id: e.id, entity: e, lifecycle: lifecycle };
}

function _test_CBD_getEntity(_w, _id) {
    if (is_undefined(_w) || is_undefined(_w.entityRegistry)) return undefined;
    var reg = _w.entityRegistry;
    if (is_struct(reg) && variable_struct_exists(reg, "get")) return reg.get(_id);
    return undefined;
}

function _test_CBD_hasComponent(_entity, _componentTypeId) {
    if (is_undefined(_entity) || !is_struct(_entity)) return false;
    if (!variable_struct_exists(_entity, "getComponent")) return false;
    var c = _entity.getComponent(_componentTypeId);
    return !is_undefined(c);
}
