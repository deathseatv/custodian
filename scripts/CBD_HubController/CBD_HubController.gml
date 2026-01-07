/// Bundle D - Hub & Character Lifecycle
/// Updated for Bundle E integration (Portal lifecycle controller).

function HubController(_world, _repo) constructor {
    world = _world;

    // Bundle D systems
    navigation = new HubNavigation();
    ui = new HubUI();
    lifecycle = new CharacterLifecycleService(_world);
    lifeSystem = new LifeSystem(_world, lifecycle);
    inhabitation = new InhabitationService(_world, navigation, lifecycle, ui);
    retirement = new RetirementService(_world, lifecycle, lifeSystem, inhabitation, ui);
    gallery = new CharacterGallery(_world);

    // Bundle E systems
    portal = new PortalLifecycleController(_world, _repo);

    init = function(_w) {
        world = _w;
        gallery.buildFromHubState(_w.hub);

        // Bundle E: ensure at least 1 slot exists for Slice 2
        if (!is_undefined(portal)) portal.ensureSlots(1);

        return true;
    };

    enterHub = function() {
        if (is_undefined(world) || is_undefined(world.activeContext)) return false;
        world.activeContext.inHub = true;
        return true;
    };

    exitHub = function() {
        if (is_undefined(world) || is_undefined(world.activeContext)) return false;
        world.activeContext.inHub = false;
        return true;
    };

    /// ---------------- Bundle E convenience wrappers ----------------

    openPortalInSlot = function(slotId, arenaId) {
        if (is_undefined(portal)) return "";
        return portal.openInSlot(slotId, arenaId);
    };

    openAndEnterSlot = function(slotId, arenaId) {
        if (is_undefined(portal)) return false;
        return portal.openAndEnterSlot(slotId, arenaId);
    };

    exitPortalToHub = function() {
        if (is_undefined(portal)) return false;
        return portal.exitToHub();
    };

    dormantPortal = function(portalId) {
        if (is_undefined(portal)) return false;
        return portal.setDormant(portalId);
    };

    closePortalDestructive = function(portalId) {
        if (is_undefined(portal)) return false;
        return portal.closeDestructive(portalId);
    };

    step = function() {
        // Hub loop coordination point.
        // Intentionally minimal: hook input/UI here once Bundle B is integrated.
        return true;
    };
}
