/// o_character_husk : Step

var INHABIT_RANGE = 24;

hovered = point_in_circle(device_mouse_x(0), device_mouse_y(0), x, y, 10);

if (hovered && mouse_check_button_pressed(mb_left)) {
	var rt = instance_find(o_hub_runtime, 0);
	if (rt != noone) {

		// Must be close to wisp (and wisp must exist)
		var w = instance_find(o_wisp, 0);
		if (w == noone) {
			rt.hub.ui.showError("No wisp present.");
			exit;
		}

		if (point_distance(w.x, w.y, x, y) > INHABIT_RANGE) {
			rt.hub.ui.showError("Too far away to inhabit.");
			exit;
		}

		if (rt.hub.inhabitation.canInhabit(character_id)) {
			rt.prompt_active = true;
			rt.prompt_character_id = character_id;
			rt.prompt_husk_inst_id = id; // store which husk was selected
			rt.hub.ui.showInhabitPrompt(character_id);
		} else {
			rt.hub.ui.showError("Cannot inhabit this character.");
		}
	}
}
