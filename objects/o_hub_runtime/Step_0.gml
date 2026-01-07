/// o_hub_runtime : Step

// If a prompt is active, only handle prompt input here.
if (prompt_active) {
	if (keyboard_check_pressed(ord("Y"))) {
		hub.inhabitation.confirmInhabit(prompt_character_id);


		// Swap control: destroy wisp, replace selected husk instance with controllable player husk
		var hx = 0;
		var hy = 0;

		if (prompt_husk_inst_id != noone && instance_exists(prompt_husk_inst_id)) {
			hx = prompt_husk_inst_id.x;
			hy = prompt_husk_inst_id.y;
			with (prompt_husk_inst_id) instance_destroy();
		} else {
			// fallback: spawn at wisp position if the husk vanished
			var w = instance_find(o_wisp, 0);
			if (w != noone) { hx = w.x; hy = w.y; }
		}

		var wisp = instance_find(o_wisp, 0);
		if (wisp != noone) with (wisp) instance_destroy();

		var p = instance_create_layer(hx, hy, "Instances", o_husk_player);
		p.character_id = prompt_character_id;

		// Save immediately so you can verify persistence
		if (!is_undefined(global.save_system)) {
			global.save_system.saveGame(global.save_slot, global.world);
			last_save_stamp = date_datetime_string(date_current_datetime());
		}

		prompt_active = false;
		prompt_character_id = undefined;
		prompt_husk_inst_id = noone;
	}
	else if (keyboard_check_pressed(ord("N")) || keyboard_check_pressed(vk_escape)) {
		SJ_Audio_UIReject();
		prompt_active = false;
	}
	exit;
}

// Debug hotkeys for persistence verification
if (keyboard_check_pressed(vk_f5)) {
	if (!is_undefined(global.save_system)) {
		global.save_system.saveGame(global.save_slot, global.world);
		last_save_stamp = date_datetime_string(date_current_datetime());
	}
}

if (keyboard_check_pressed(vk_f9)) {
	if (!is_undefined(global.save_system)) {
		global.world = global.save_system.loadGame(global.save_slot);
		
		// Re-init hub controller for newly-loaded world
		hub = new HubController(global.world);
		hub.init(global.world);
		
		Slice1_RebuildHubFromWorld();
		
	}
}

// DEV: wipe saves (slot + hub + snapshots + portals) and reboot hub
if (keyboard_check_pressed(vk_f12)) {
    // wipe on disk
    global.persist_repo.deleteAllSaves();

    // reset in memory
    global.world = new WorldState();

    // rebuild hub controller + visuals
    hub = new HubController(global.world);
    hub.init(global.world);
    Slice1_RebuildHubFromWorld();

    show_debug_message("DEV: deleted all saves + reset world");
}


// Normal hub loop tick (currently minimal in your stub)
hub.step();
