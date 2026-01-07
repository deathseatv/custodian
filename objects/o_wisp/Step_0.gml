/// o_wisp : Step

// If currently controlling a character, wisp should be idle/invisible.
if (!is_undefined(global.world)
&&  !is_undefined(global.world.activeContext)
&&  global.world.activeContext.inhabitedCharacterId != undefined) {
	visible = false;
	exit;
} else {
	visible = true;
}

var keyD = string_byte_at("D", 1);
var keyA = string_byte_at("A", 1);
var keyS = string_byte_at("S", 1);
var keyW = string_byte_at("W", 1);

var dx = original_keyboard_check(keyD) - original_keyboard_check(keyA);
var dy = original_keyboard_check(keyS) - original_keyboard_check(keyW);


x += dx * move_speed;
y += dy * move_speed;
