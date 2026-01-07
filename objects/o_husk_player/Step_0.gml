/// o_husk_player : Step

// If world says we're not inhabited anymore, self-destruct (future-proof)
var inhab = undefined;
if (!is_undefined(global.world)
&&  !is_undefined(global.world.activeContext)) {
	inhab = global.world.activeContext.inhabitedCharacterId;
}

// Only destroy if we're sure the world has a different inhabited id.
if (inhab != undefined) {
	if (string(inhab) != string(character_id)) {
		instance_destroy();
		exit;
	}
}

// Use numeric key codes to avoid ord() collisions:
// A=65 D=68 W=87 S=83
var dx = original_keyboard_check(68) - original_keyboard_check(65);
var dy = original_keyboard_check(83) - original_keyboard_check(87);

x += dx * move_speed;
y += dy * move_speed;
