/// o_slice0_hud : Draw GUI
draw_set_alpha(1);
draw_set_color(c_white);

var _y = 16;

draw_text(16, _y, "Slice 0 Verify"); _y += 20;

if (is_undefined(global.world)) {
    draw_text(16, _y, "global.world: undefined"); _y += 20;
} else {
    draw_text(16, _y, "schemaVersion: " + string(global.world.schemaVersion)); _y += 20;

    if (!is_undefined(global.world.activeContext)) {
        draw_text(16, _y, "inHub: " + string(global.world.activeContext.inHub)); _y += 20;
        draw_text(16, _y, "activePortalId: " + string(global.world.activeContext.activePortalId)); _y += 20;
        draw_text(16, _y, "inhabitedCharacterId: " + string(global.world.activeContext.inhabitedCharacterId)); _y += 20;
    } else {
        draw_text(16, _y, "activeContext: undefined"); _y += 20;
    }

    // show a test value we will mutate
    var v = undefined;
    if (!is_undefined(global.world.globalState)) {
        if (variable_struct_exists(global.world.globalState, "slice0_counter")) {
            v = global.world.globalState.slice0_counter;
        }
    }
    draw_text(16, _y, "slice0_counter: " + string(v)); _y += 20;
}

draw_text(16, _y, "Keys: [R]=randomize counter, [S]=save, [L]=reload"); _y += 20;
