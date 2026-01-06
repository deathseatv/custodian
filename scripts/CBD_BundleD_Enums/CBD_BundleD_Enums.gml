/// Bundle D - Hub & Character Lifecycle
/// Runtime enum-like tables for tests and gameplay code.
///
/// NOTE:
/// The test suite probes for these via `variable_global_exists()` and also
/// uses `CharacterLifeState.INACTIVE` style access. To keep this reliable in
/// all runtimes, we bind *struct tables* into global variables.

var _life = {
    INACTIVE : 0,
    ACTIVE   : 1,
    DEAD     : 2,
    RETIRED  : 3
};

var _mode = {
    Wisp      : 0,
    Character : 1
};

// Primary names expected by tests
if (!variable_global_exists("CharacterLifeState")) variable_global_set("CharacterLifeState", _life);
if (!variable_global_exists("HubControlMode"))     variable_global_set("HubControlMode",     _mode);

// Namespaced aliases used by some helpers
if (!variable_global_exists("CBD_CharacterLifeState")) variable_global_set("CBD_CharacterLifeState", _life);
if (!variable_global_exists("CBD_HubControlMode"))     variable_global_set("CBD_HubControlMode",     _mode);
