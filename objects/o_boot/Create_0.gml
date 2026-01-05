/// o_boot : Create

// prevent duplicates (if you ever re-enter rm_hub)
if (instance_number(o_boot) > 1) {
    instance_destroy();
    exit;
}

// Choose a slot strategy (fastest: hardcode slot 0)
global.save_slot = 0;

// Construct persistence pieces
// Adjust these to match your constructors in scripts.zip
global.persist_repo = new PersistenceRepository();
global.save_system  = new SaveSystem(global.persist_repo);

// Load or create world
var ws = global.save_system.loadGame(global.save_slot);
if (is_undefined(ws) || ws == noone) {
    ws = new WorldState();
    // Ensure sane defaults
    ws.activeContext = new ActiveContext();
    ws.activeContext.inHub = true;
}

// Make authoritative
global.world = ws;

// Enforce hub root (Slice 0)
global.world.activeContext.inHub = true;
