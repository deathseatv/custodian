/// test_CBD_HubController.gml
/// Covers orchestration wiring and basic enter/exit hub behavior.

function test_CBD_HubController() {
    section("Bundle D - HubController", function() {
        test("HubController constructs and wires services", function() {
            var w = _test_CBD_makeWorld();
            var hc = new HubController(w);

            expect(!is_undefined(hc.navigation)).toBeTruthy();
            expect(!is_undefined(hc.ui)).toBeTruthy();
            expect(!is_undefined(hc.lifecycle)).toBeTruthy();
            expect(!is_undefined(hc.lifeSystem)).toBeTruthy();
            expect(!is_undefined(hc.inhabitation)).toBeTruthy();
            expect(!is_undefined(hc.retirement)).toBeTruthy();
            expect(!is_undefined(hc.gallery)).toBeTruthy();
        });

        test("enterHub sets activeContext.inHub true", function() {
            var ctx = _test_CBD_makeController();
            var w = ctx.world;
            var hc = ctx.hub;

            w.activeContext.inHub = false;
            expect(hc.enterHub()).toBeTruthy();
            expect(w.activeContext.inHub).toBeTruthy();
        });

        test("exitHub sets activeContext.inHub false", function() {
            var ctx = _test_CBD_makeController();
            var w = ctx.world;
            var hc = ctx.hub;

            w.activeContext.inHub = true;
            expect(hc.exitHub()).toBeTruthy();
            expect(w.activeContext.inHub == false).toBeTruthy();
        });

        test("step returns true (no-op coordinator)", function() {
            var ctx = _test_CBD_makeController();
            expect(ctx.hub.step()).toBeTruthy();
        });
    });
}
