/// CBD_EntityRegistry_Serialization.gml
/// Free functions for serializing EntityRegistry WITHOUT ds_map usage.
/// Assumes registry stores entities in a struct-backed map/dictionary or array.
/// If your EntityRegistry uses a different internal field name, update `_get_store()` only.

function _CBD_ER__get_store(_reg) {
    // Common patterns:
    // - _reg.map (struct of entities keyed by id)
    // - _reg.entities (struct map)
    // - _reg.list (array)
    if (is_undefined(_reg) || !is_struct(_reg)) return undefined;

    if (variable_struct_exists(_reg, "map")) return _reg.map;
    if (variable_struct_exists(_reg, "entities")) return _reg.entities;
    if (variable_struct_exists(_reg, "list")) return _reg.list;

    return undefined;
}

/// @returns array of serialized entities (each entity is a struct from Entity.toStruct()).
function EntityRegistry_ToStruct(_reg) {
    if (is_undefined(_reg) || !is_struct(_reg)) return [];

    // Support Bundle A EntityRegistry (ds_map-backed via _map)
    if (variable_struct_exists(_reg, "_map")) {
        var m = _reg._map;
        if (ds_exists(m, ds_type_map)) {
            var keysM = ds_map_keys_to_array(m);
            var outM = [];
            for (var iM = 0; iM < array_length(keysM); iM++) {
                var kM = keysM[iM];
                var eM = m[? kM];
                if (!is_undefined(eM) && is_struct(eM) && variable_struct_exists(eM, "toStruct")) {
                    array_push(outM, eM.toStruct());
                }
            }
            return outM;
        }
    }

    var store = _CBD_ER__get_store(_reg);
    if (is_undefined(store)) return [];

    // Case A: array store
    if (is_array(store)) {
        var outA = [];
        var nA = array_length(store);
        for (var i = 0; i < nA; i++) {
            var e = store[i];
            if (!is_undefined(e) && is_struct(e) && variable_struct_exists(e, "toStruct")) {
                array_push(outA, e.toStruct());
            }
        }
        return outA;
    }

    // Case B: struct-map store: iterate keys with variable_struct_get_names
    if (is_struct(store)) {
        var keys = variable_struct_get_names(store);
        var outB = [];
        var nB = array_length(keys);
        for (var j = 0; j < nB; j++) {
            var k = keys[j];
            var e2 = variable_struct_get(store, k);
            if (!is_undefined(e2) && is_struct(e2) && variable_struct_exists(e2, "toStruct")) {
                array_push(outB, e2.toStruct());
            }
        }
        return outB;
    }

    return [];
}

/// @desc Rebuild registry from array of entity structs.
function EntityRegistry_FromStruct(_arr) {
    var reg = new EntityRegistry();

    if (is_undefined(_arr) || !is_array(_arr)) return reg;

    var n = array_length(_arr);
    for (var i = 0; i < n; i++) {
        var es = _arr[i];
        if (is_undefined(es) || !is_struct(es)) continue;

        // Use your existing entity deserializer/constructor
        // Bundle A already has Entity_FromStruct in the serializer suite.
        var e = Entity_FromStruct(es);

        // Prefer registry's add() if present
        if (is_struct(reg) && variable_struct_exists(reg, "add")) {
            reg.add(e);
        } else {
            // Fallback: put into a detected store
            var store = _CBD_ER__get_store(reg);
            if (is_undefined(store)) {
                // Default to creating reg.entities as struct-map
                reg.entities = {};
                store = reg.entities;
            }
            if (is_struct(store)) {
                // Ensure entity has id
                if (variable_struct_exists(e, "id")) {
                    variable_struct_set(store, e.id, e);
                }
            } else if (is_array(store)) {
                array_push(store, e);
            }
        }
    }

    return reg;
}
