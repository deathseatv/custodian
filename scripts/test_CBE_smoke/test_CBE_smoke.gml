/// test_CBE_smoke.gml
/// Bundle E smoke tests
/// Generated: 20260107143348 UTC

function test_CBE_smoke() {
    section("Bundle E Smoke", function() {
        test("Bundle E constructors exist", function() {
            expect(is_callable(PortalLifecycleController)).toBeTruthy();
            expect(is_callable(PortalSlotService)).toBeTruthy();
            expect(is_callable(PortalFactory)).toBeTruthy();
            expect(is_callable(StasisController)).toBeTruthy();
            expect(is_callable(PortalTransitionService)).toBeTruthy();
        });

        test("ensureSlots creates at least one slot", function() {
            var w = test_cbe_world(0);
            var repo = test_cbe_repo("test_cbe_smoke_repo");
            var ctl = new PortalLifecycleController(w, repo);
            ctl.ensureSlots(1);
            expect(is_array(w.hub.portalSlots)).toBeTruthy();
            expect(array_length(w.hub.portalSlots)).toBe(1);
            repo.deleteAllSaves();
        });
    });
}
