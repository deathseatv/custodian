/// Bundle D - Hub & Character Lifecycle
/// Hub navigation helpers for selecting character husks.

function CharacterGallery(_world) constructor {
    world = _world;

    buildFromHubState = function(_hub) {
        return true;
    };

    getHuskIds = function() {
        if (is_undefined(world) || is_undefined(world.hub)) return [];
        if (!is_array(world.hub.entities)) return [];
        return world.hub.entities;
    };

    findNearestHusk = function(_pos) {
        // Placeholder: returns first husk id.
        var ids = getHuskIds();
        if (array_length(ids) <= 0) return undefined;
        return ids[0];
    };
}
