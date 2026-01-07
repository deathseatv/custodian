/// CBE_StasisController.gml
/// Bundle E - Stasis Controller
///
/// Bundle E requirement: when the player is not inside a portal instance, its
/// simulation should not advance. For now, Bundle E expresses this as a boolean
/// flag on PortalInstanceState (`stasis`). Portal room logic (future slices)
/// should consult this flag to skip ticking AI, DOT, timers, etc.

function StasisController() constructor {

    applyStasis = function(portalInstanceState, enabled) {
        if (is_undefined(portalInstanceState)) return false;
        portalInstanceState.stasis = (enabled == true);
        return true;
    };

    isInStasis = function(portalInstanceState) {
        if (is_undefined(portalInstanceState)) return true;
        return (portalInstanceState.stasis == true);
    };
}
