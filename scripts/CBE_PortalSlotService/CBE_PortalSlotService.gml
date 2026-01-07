/// CBE_PortalSlotService.gml
/// Bundle E - Hub Portal Slot Service

/// @desc Utilities for locating and mutating PortalSlotState entries in HubState.
function PortalSlotService(_world) constructor {
    world = _world;

    _hub = function() {
        if (is_undefined(world) || is_undefined(world.hub)) return undefined;
        return world.hub;
    };

    _findSlotIndex = function(_slotId) {
        var hub = _hub();
        if (is_undefined(hub) || !is_array(hub.portalSlots)) return -1;

        var sid = string(_slotId);
        for (var i = 0; i < array_length(hub.portalSlots); i++) {
            var slot = hub.portalSlots[i];

            // Older saves may store raw strings
            if (is_string(slot) || is_real(slot)) {
                if (string(slot) == sid) return i;
            } else if (is_struct(slot) && variable_struct_exists(slot, "slotId")) {
                if (string(slot.slotId) == sid) return i;
            }
        }
        return -1;
    };

    /// @desc Get a PortalSlotState by slotId. Returns undefined if missing.
    getSlot = function(slotId) {
        var hub = _hub();
        if (is_undefined(hub)) return undefined;

        var idx = _findSlotIndex(slotId);
        if (idx < 0) return undefined;

        var slot = hub.portalSlots[idx];
        if (is_string(slot) || is_real(slot)) slot = new PortalSlotState(slot);
        return slot;
    };

    /// @desc Ensure slots exist. count is number of slots.
    ensureCount = function(count) {
        var hub = _hub();
        if (is_undefined(hub)) return false;
        return PortalSlots_EnsureCount(hub, count);
    };

    /// @desc Bind a portalId to a slot and ensure the slot exists.
    bindPortal = function(slotId, portalId) {
        var hub = _hub();
        if (is_undefined(hub)) return false;

        var sid = string(slotId);
        var idx = _findSlotIndex(sid);
        if (idx < 0) {
            // If the caller passes "3" and only 1 slot exists, grow up to that index+1.
            var desired = real(sid) + 1;
            if (desired < 1) desired = 1;
            PortalSlots_EnsureCount(hub, desired);
            idx = _findSlotIndex(sid);
            if (idx < 0) return false;
        }

        var slot = hub.portalSlots[idx];
        if (is_string(slot) || is_real(slot)) slot = new PortalSlotState(slot);
        slot.portalId = string(portalId);
        hub.portalSlots[idx] = slot;
        return true;
    };

    /// @desc Clear a slot's portal binding and unlock it.
    clearSlot = function(slotId) {
        var hub = _hub();
        if (is_undefined(hub)) return false;

        var idx = _findSlotIndex(slotId);
        if (idx < 0) return false;

        var slot = hub.portalSlots[idx];
        if (is_string(slot) || is_real(slot)) slot = new PortalSlotState(slot);

        slot.portalId = "";
        slot.locked = false;
        hub.portalSlots[idx] = slot;
        return true;
    };

    lockSlot = function(slotId) {
        var hub = _hub();
        if (is_undefined(hub)) return false;

        var idx = _findSlotIndex(slotId);
        if (idx < 0) return false;

        var slot = hub.portalSlots[idx];
        if (is_string(slot) || is_real(slot)) slot = new PortalSlotState(slot);

        slot.locked = true;
        hub.portalSlots[idx] = slot;
        return true;
    };

    unlockSlot = function(slotId) {
        var hub = _hub();
        if (is_undefined(hub)) return false;

        var idx = _findSlotIndex(slotId);
        if (idx < 0) return false;

        var slot = hub.portalSlots[idx];
        if (is_string(slot) || is_real(slot)) slot = new PortalSlotState(slot);

        slot.locked = false;
        hub.portalSlots[idx] = slot;
        return true;
    };

    /// @desc Find the slotId that references the given portalId. Returns "" if not found.
    findSlotIdByPortal = function(portalId) {
        var hub = _hub();
        if (is_undefined(hub) || !is_array(hub.portalSlots)) return "";

        var pid = string(portalId);
        for (var i = 0; i < array_length(hub.portalSlots); i++) {
            var slot = hub.portalSlots[i];
            if (is_struct(slot) && variable_struct_exists(slot, "portalId")) {
                if (string(slot.portalId) == pid) return string(slot.slotId);
            }
        }
        return "";
    };
}
