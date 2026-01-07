/// CBE_PortalLifecycleController.gml
/// Bundle E - Portal Lifecycle & Stasis
///
/// Responsibilities:
/// - Create/open portal instances and bind them to hub slots
/// - Enter/exit portals (ActiveContext updates)
/// - Mark portals Dormant and lock slots
/// - Explicit destructive closure (delete portal file + unbind slot)
/// - Toggle stasis flags

function PortalLifecycleController(_world, _repo, _logger) constructor {
    world = _world;
    repo = _repo; // PersistenceRepository
    logger = is_undefined(_logger) ? new Logger() : _logger;

    slots = new PortalSlotService(world);
    factory = new PortalFactory();
    stasis = new StasisController();
    transition = new PortalTransitionService(world);

    _getPortal = function(portalId) {
        if (is_undefined(world) || is_undefined(world.portals)) return undefined;
        return world.portals.get(string(portalId));
    };

    _setPortal = function(portalInstanceState) {
        if (is_undefined(world) || is_undefined(world.portals)) return false;
        world.portals.set(portalInstanceState.portalId, portalInstanceState);
        return true;
    };

    _removePortal = function(portalId) {
        if (is_undefined(world) || is_undefined(world.portals)) return false;

        // PortalRegistryState doesn't expose remove(), so delete from map directly.
        // NOTE: PortalRegistryState's internal map is `_map` by convention in this project.
        var pid = string(portalId);
        if (!is_undefined(world.portals._map) && ds_exists(world.portals._map, ds_type_map)) {
            if (ds_map_exists(world.portals._map, pid)) ds_map_delete(world.portals._map, pid);
            return true;
        }

        // Fallback: no-op if internal map isn't available.
        return false;
    };

    ensureSlots = function(count) {
        return slots.ensureCount(count);
    };

    /// @desc Open a portal in a slot (creates if empty). Returns portalId or "" on failure.
    openInSlot = function(slotId, arenaId) {
        // Ensure slot exists
        slots.ensureCount(real(slotId) + 1);

        var slot = slots.getSlot(slotId);
        if (is_undefined(slot)) return "";

        if (slot.locked) return "";

        // If already bound, ensure portal exists and is Open.
        if (slot.portalId != "") {
            var existing = _getPortal(slot.portalId);
            if (!is_undefined(existing)) {
                if (existing.state == PortalState.Empty) existing.state = PortalState.Open;
                _setPortal(existing);
                return existing.portalId;
            }

            // Bound id but missing portal instance -> clear binding
            slots.clearSlot(slotId);
        }

        // Create new portal instance
        var p = factory.create(arenaId);
        _setPortal(p);
        slots.bindPortal(slotId, p.portalId);

        return p.portalId;
    };

    /// @desc Enter a portal by portalId. Returns true if successful.
    enter = function(portalId) {
        var p = _getPortal(portalId);
        if (is_undefined(p)) return false;

        // Dormant is not enterable until explicitly resolved/closed.
        if (p.state == PortalState.Dormant) return false;

        p.state = PortalState.Open;
        stasis.applyStasis(p, false);
        _setPortal(p);

        transition.hubToPortal(p.portalId);
        return true;
    };

    /// @desc Convenience: open (if needed) then enter a portal slot.
    openAndEnterSlot = function(slotId, arenaId) {
        var pid = openInSlot(slotId, arenaId);
        if (pid == "") return false;
        return enter(pid);
    };

    /// @desc Exit current portal back to hub. Returns true if a portal was active.
    exitToHub = function() {
        if (is_undefined(world) || is_undefined(world.activeContext)) return false;

        var pid = string(world.activeContext.activePortalId);
        if (pid == "") {
            transition.portalToHub();
            return false;
        }

        var p = _getPortal(pid);
        if (!is_undefined(p)) {
            // When leaving a portal, it enters stasis.
            stasis.applyStasis(p, true);
            _setPortal(p);
        }

        transition.portalToHub();
        return true;
    };

    /// @desc Mark a portal Dormant and lock its slot. Returns true if portal exists.
    setDormant = function(portalId) {
        var p = _getPortal(portalId);
        if (is_undefined(p)) return false;

        p.state = PortalState.Dormant;
        stasis.applyStasis(p, true);
        _setPortal(p);

        var sid = slots.findSlotIdByPortal(p.portalId);
        if (sid != "") slots.lockSlot(sid);

        // If this portal was active, kick player back to hub.
        if (!is_undefined(world) && !is_undefined(world.activeContext)) {
            if (string(world.activeContext.activePortalId) == p.portalId) {
                transition.portalToHub();
            }
        }

        return true;
    };

    /// @desc Explicit destructive closure:
    /// - deletes portal file on disk (if repo provided)
    /// - removes from in-memory registry
    /// - unbinds and unlocks slot
    closeDestructive = function(portalId) {
        var pid = string(portalId);

        // Unbind slot (if any)
        var sid = slots.findSlotIdByPortal(pid);
        if (sid != "") slots.clearSlot(sid);

        // If active, return to hub and clear selection
        if (!is_undefined(world) && !is_undefined(world.activeContext)) {
            if (string(world.activeContext.activePortalId) == pid) {
                transition.portalToHub();
                transition.clearActivePortal();
            }
        }

        // Remove in-memory portal
        _removePortal(pid);

        // Delete on disk so loadGame fallback doesn't resurrect it
        if (!is_undefined(repo) && is_struct(repo) && variable_struct_exists(repo, "deletePortal")) {
            repo.deletePortal(pid);
        }

        return true;
    };
}
