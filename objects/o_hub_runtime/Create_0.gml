/// o_hub_runtime : Create
hub = new HubController(global.world);
hub.init(global.world);

Slice1_RebuildHubFromWorld();

// Prompt state
prompt_active = false;
prompt_character_id = undefined;

// Spawn/ensure hub actors exist
if (instance_number(o_wisp) == 0) {
	instance_create_layer(80, 120, "Instances", o_wisp);
}

// Ensure at least N character entities exist + husk instances exist
Hub_Slice1_EnsureCharactersAndHusks(3);

prompt_husk_inst_id = noone;
last_save_stamp = "";