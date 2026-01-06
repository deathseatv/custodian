/// Bundle D - Hub & Character Lifecycle
/// Orchestrates hub navigation + character lifecycle services.

function HubController(_world) constructor {
    world = _world;
    navigation = new HubNavigation();
    ui = new HubUI();
    lifecycle = new CharacterLifecycleService(_world);
    lifeSystem = new LifeSystem(_world, lifecycle);
    inhabitation = new InhabitationService(_world, navigation, lifecycle, ui);
    retirement = new RetirementService(_world, lifecycle, lifeSystem, inhabitation, ui);
    gallery = new CharacterGallery(_world);

    init = function(_w) {
        world = _w;
        gallery.buildFromHubState(_w.hub);
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

    step = function() {
        // Hub loop coordination point.
        // Intentionally minimal: hook input/UI here once Bundle B is integrated.
        return true;
    };
}
