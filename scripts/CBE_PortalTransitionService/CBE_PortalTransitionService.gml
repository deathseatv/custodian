/// CBE_PortalTransitionService.gml
/// Bundle E - ActiveContext transitions between hub and portal.

function PortalTransitionService(_world) constructor {
    world = _world;

    /// @desc Move from hub into a portal instance.
    hubToPortal = function(portalId) {
        if (is_undefined(world) || is_undefined(world.activeContext)) return false;
        world.activeContext.inHub = false;
        world.activeContext.activePortalId = string(portalId);
        return true;
    };

    /// @desc Move from portal back to hub.
    portalToHub = function() {
        if (is_undefined(world) || is_undefined(world.activeContext)) return false;
        world.activeContext.inHub = true;
        // Keep activePortalId as "last visited" (useful for UI); change if desired.
        return true;
    };

    /// @desc Clear active portal selection (optional helper).
    clearActivePortal = function() {
        if (is_undefined(world) || is_undefined(world.activeContext)) return false;
        world.activeContext.activePortalId = "";
        return true;
    };
}
