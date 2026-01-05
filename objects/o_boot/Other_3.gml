/// o_boot : Game End
if (!is_undefined(global.save_system) && !is_undefined(global.world)) {
    global.save_system.saveGame(global.save_slot, global.world);
}
