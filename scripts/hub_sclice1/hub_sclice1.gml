/// Creates N character entities if none exist, and spawns husk instances.
/// Requires Bundle A Entity/Component/EntityRegistry and Bundle D component helpers.

function Hub_Slice1_EnsureCharactersAndHusks(_minCount) {
	if (is_undefined(global.world)) return false;

	// Make sure hub.entities exists
	if (is_undefined(global.world.hub.entities) || !is_array(global.world.hub.entities)) {
		global.world.hub.entities = [];
	}

	// Seed entities if needed
	var have = array_length(global.world.hub.entities);
	if (have < _minCount) {
		var need = _minCount - have;

		for (var i = 0; i < need; i++) {
			var e = new Entity(undefined, "character");

			// Character + life + hub presence (Bundle D helpers exist in scripts.zip)
			e.addComponent(CharacterComponent_Create("Husk " + string(have + i + 1), "", ""));
			e.addComponent(LifeComponent_Create(3));
			e.addComponent(HubPresenceComponent_Create(have + i, ""));

			global.world.entityRegistry.add(e);
			array_push(global.world.hub.entities, e.id);
		}

		// Persist immediately so “inhabitedCharacterId” has something real to point at next boot.
		if (!is_undefined(global.save_system)) {
			global.save_system.saveGame(global.save_slot, global.world);
		}
	}

	// Spawn husk instances for each id if not already present
	var ids = global.world.hub.entities;
	for (var k = 0; k < array_length(ids); k++) {
		var _id = ids[k];
		if (!Hub_Slice1_HuskInstanceExists(_id)) {
			var hx = room_width * 0.5;
			var hy = room_height * 0.5 + k * 48;


			var inst = instance_create_layer(hx, hy, "Instances", o_character_husk);
			inst.character_id = _id;
		}
	}

	return true;
}

function Hub_Slice1_HuskInstanceExists(_id) {
	var it = instance_find(o_character_husk, 0);
	while (it != noone) {
		if (it.character_id == string(_id)) return true;
		it = instance_find(o_character_husk, instance_number(o_character_husk)); // forces noone; loop alternative below
	}
	// Better approach: brute iterate
	with (o_character_husk) {
		if (character_id == string(_id)) return true;
	}
	return false;
}

/// Slice1_RebuildHubFromWorld()
/// Rebuilds hub visuals strictly from global.world (Slice 1 dev glue)
function Slice1_RebuildHubFromWorld() {
    // Clear visuals
    with (o_wisp) instance_destroy();
    with (o_husk_player) instance_destroy();
    with (o_character_husk) instance_destroy();

    // Always respawn husk visuals (gallery)
    Hub_Slice1_EnsureCharactersAndHusks(3);

    // Spawn control based on authoritative state
    var inhab = undefined;
    if (!is_undefined(global.world) && !is_undefined(global.world.activeContext)) {
        inhab = global.world.activeContext.inhabitedCharacterId;
    }

    if (inhab == undefined) {
        instance_create_layer(80, 120, "Instances", o_wisp);
        return;
    }

    // Find the husk position for the inhabited character
    var hx = 320;
    var hy = 240;

    with (o_character_husk) {
        if (string(character_id) == string(inhab)) {
            hx = x;
            hy = y;
        }
    }

    // Remove duplicate husk visual for the controlled character
    with (o_character_husk) {
        if (string(character_id) == string(inhab)) instance_destroy();
    }

    var p = instance_create_layer(hx, hy, "Instances", o_husk_player);
    p.character_id = inhab;
}
