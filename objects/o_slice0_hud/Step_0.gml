/// o_slice0_hud : Step

// Mutate a value in globalState
if (keyboard_check_pressed(ord("R"))) {
    if (!is_undefined(global.world)) {
        if (is_undefined(global.world.globalState)) global.world.globalState = {};
        global.world.globalState.slice0_counter = irandom(999999);
    }
}
/*
// Manual save
if (keyboard_check_pressed(ord("S"))) {
    if (!is_undefined(global.save_system) && !is_undefined(global.world)) {
        global.save_system.saveGame(global.save_slot, global.world);
    }
}
*/
// Manual reload (re-reads slot pointer + snapshot)
if (keyboard_check_pressed(ord("L"))) {
    if (!is_undefined(global.save_system)) {
        var w = global.save_system.loadGame(global.save_slot);
        if (!is_undefined(w)) global.world = w;
    }
}
