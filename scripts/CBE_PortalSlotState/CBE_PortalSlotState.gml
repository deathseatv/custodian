/// CBE_PortalSlotState.gml
/// Bundle E - Portal Slot State

/// @desc Portal slot state stored in HubState.portalSlots.
function PortalSlotState(_slotId) constructor {
    slotId = string(_slotId);
    portalId = "";
    locked = false;

    toStruct = function() {
        return {
            slotId: slotId,
            portalId: portalId,
            locked: locked
        };
    };
}

/// @desc Hydrate a slot from a struct (e.g., JSON parse result)
function PortalSlotState_FromStruct(s) {
    var slotId = "";
    if (!is_undefined(s) && is_struct(s) && variable_struct_exists(s, "slotId")) {
        slotId = s.slotId;
    }

    var slot = new PortalSlotState(slotId);
    if (!is_undefined(s) && is_struct(s)) {
        if (variable_struct_exists(s, "portalId")) slot.portalId = string(s.portalId);
        if (variable_struct_exists(s, "locked")) slot.locked = (s.locked == true);
    }
    return slot;
}

/// @desc Ensure HubState.portalSlots contains N slots (slotId = "0".."N-1").
function PortalSlots_EnsureCount(hubState, count) {
    if (is_undefined(hubState) || is_undefined(count)) return false;
    if (!is_array(hubState.portalSlots)) hubState.portalSlots = [];

    // Grow with default slots.
    for (var i = array_length(hubState.portalSlots); i < count; i++) {
        hubState.portalSlots[i] = new PortalSlotState(i);
    }

    // Normalize any older saves that stored string ids.
    for (var j = 0; j < array_length(hubState.portalSlots); j++) {
        var v = hubState.portalSlots[j];
        if (is_string(v) || is_real(v)) {
            hubState.portalSlots[j] = new PortalSlotState(string(v));
        }
    }

    return true;
}
