/// Bundle D - Hub & Character Lifecycle
/// Component factory helpers (built on Bundle As Component + Entity).

function CharacterComponent_Create(_displayName, _portraitId, _weaponType) {
    if (is_undefined(global.CharacterLifeState)) {
        global.CharacterLifeState = { INACTIVE: 0, ACTIVE: 1, DEAD: 2, RETIRED: 3 };
    }
    var data = {
        displayName: is_undefined(_displayName) ? "Unnamed" : string(_displayName),
        portraitId: is_undefined(_portraitId) ? "" : string(_portraitId),
        weaponType: is_undefined(_weaponType) ? "" : string(_weaponType),
        lifeState: global.CharacterLifeState.INACTIVE
    };
    return new Component("character", data);
}

function LifeComponent_Create(_maxLives) {
    var ml = is_undefined(_maxLives) ? 3 : max(0, floor(_maxLives));
    var data = {
        livesRemaining: ml,
        maxLives: ml
    };
    return new Component("life", data);
}

function HubPresenceComponent_Create(_gallerySlotIndex, _huskVisualId) {
    var data = {
        gallerySlotIndex: is_undefined(_gallerySlotIndex) ? -1 : floor(_gallerySlotIndex),
        huskVisualId: is_undefined(_huskVisualId) ? "" : string(_huskVisualId)
    };
    return new Component("hub_presence", data);
}

function Character_GetComponent(_entity) {
    if (is_undefined(_entity)) return undefined;
    return _entity.getComponent("character");
}

function Life_GetComponent(_entity) {
    if (is_undefined(_entity)) return undefined;
    return _entity.getComponent("life");
}

function HubPresence_GetComponent(_entity) {
    if (is_undefined(_entity)) return undefined;
    return _entity.getComponent("hub_presence");
}
