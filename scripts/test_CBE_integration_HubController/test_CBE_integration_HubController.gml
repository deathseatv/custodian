/// test_CBE_integration_HubController.gml
/// Bundle E integration: HubController wrappers
/// Generated: 20260107143348 UTC

function test_CBE_integration_HubController() {
    section("Integration: HubController", function() {
        test("HubController portal wrappers call into PortalLifecycleController", function() {
            var repo = test_cbe_repo("test_cbe_integr_hub_repo");
            var w = test_cbe_world(1);

            var hub = new HubController(w, repo);
            hub.init(w);

            var ok = hub.openAndEnterSlot("0", "arena_H");
            expect(ok).toBeTruthy();
            expect(w.activeContext.inHub).toBeFalsy();
            expect(string(w.activeContext.activePortalId) != "").toBeTruthy();

            var pid = string(w.activeContext.activePortalId);
            expect(w.portals.has(pid)).toBeTruthy();

            // Exit via wrapper
            expect(hub.exitPortalToHub()).toBeTruthy();
            expect(w.activeContext.inHub).toBeTruthy();
            expect(w.portals.get(pid).stasis).toBeTruthy();

            // Dormant via wrapper
            expect(hub.dormantPortal(pid)).toBeTruthy();
            expect(w.portals.get(pid).state).toBe(PortalState.Dormant);

            // Close via wrapper should clear slot and delete file if present
            repo.writePortalInstance(w.schemaVersion, w.portals.get(pid));
            expect(hub.closePortalDestructive(pid)).toBeTruthy();
            expect(w.portals.has(pid)).toBeFalsy();
            expect(w.hub.portalSlots[0].portalId).toBe("");

            repo.deleteAllSaves();
        });
    });
}
