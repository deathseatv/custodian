/// o_hub_runtime : Draw GUI
if (!prompt_active) exit;

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var cx = display_get_gui_width() * 0.5;
var cy = display_get_gui_height() * 0.5;

draw_text(cx, cy,
	"Inhabit this husk?\n\nY = Yes    N/Esc = No"
);

// Slice 1 debug overlay (top-left)
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var x0 = 8;
var y0 = 8;

var inhab = "none";
if (!is_undefined(global.world)
&&  !is_undefined(global.world.activeContext)
&&  global.world.activeContext.inhabitedCharacterId != undefined) {
	inhab = string(global.world.activeContext.inhabitedCharacterId);
}

draw_text(x0, y0,
	"S1 DEBUG\n" +
	"Inhabited: " + inhab + "\n" +
	"Last save: " + string(last_save_stamp) + "\n" +
	"F5=Save  F9=Reload"
);
