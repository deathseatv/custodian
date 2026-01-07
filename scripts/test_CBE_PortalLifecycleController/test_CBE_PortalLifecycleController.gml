/// test_CBE_PortalLifecycleController.gml
/// Bundle E - PortalLifecycleController core logic
/// Generated: 20260107143348 UTC

function test_CBE_PortalLifecycleController() {
    section("PortalLifecycleController", function() {
        test("openInSlot creates portal and binds slot", function() {
            var w = test_cbe_world(1);
            var repo = test_cbe_repo("test_cbe_lifecycle_repo_open");
            var ctl = new PortalLifecycleController(w, repo);

            var pid = ctl.openInSlot("0", "arena_A");
            expect(pid != "").toBeTruthy();
            expect(test_cbe_has_portal(w, pid)).toBeTruthy();

            var slot = (new PortalSlotService(w)).getSlot("0");
            expect(slot.portalId).toBe(pid);

            var p = w.portals.get(pid);
            expect(p.state).toBe(PortalState.Open);
            expect(p.stasis).toBeFalsy();
            expect(p.arenaId).toBe("arena_A");

            repo.deleteAllSaves();
        });

        test("openInSlot reuses bound portal if present; clears stale binding", function() {
            var w = test_cbe_world(1);
            var repo = test_cbe_repo("test_cbe_lifecycle_repo_reuse");
            var ctl = new PortalLifecycleController(w, repo);

            var pid1 = ctl.openInSlot("0", "arena_A");
            var pid2 = ctl.openInSlot("0", "arena_B");
            expect(pid2).toBe(pid1); // reuse
            expect(w.portals.get(pid1).arenaId).toBe("arena_A"); // factory not called again

            // Simulate stale binding: remove portal, then open again should clear and create new
            w.portals.remove(pid1);
            var pid3 = ctl.openInSlot("0", "arena_C");
            expect(pid3 != "").toBeTruthy();
            expect(pid3 == pid1).toBeFalsy();
            expect((new PortalSlotService(w)).getSlot("0").portalId).toBe(pid3);
            expect(w.portals.get(pid3).arenaId).toBe("arena_C");

            repo.deleteAllSaves();
        });

        test("enter sets active context and removes stasis", function() {
            var w = test_cbe_world(1);
            var repo = test_cbe_repo("test_cbe_lifecycle_repo_enter");
            var ctl = new PortalLifecycleController(w, repo);

            var pid = ctl.openInSlot("0", "arena_E");
            // Put portal into stasis first, then enter should clear stasis
            w.portals.get(pid).stasis = true;

            expect(ctl.enter(pid)).toBeTruthy();
            expect(w.activeContext.inHub).toBeFalsy();
            expect(string(w.activeContext.activePortalId)).toBe(pid);
            expect(w.portals.get(pid).stasis).toBeFalsy();

            repo.deleteAllSaves();
        });

        test("exitToHub sets stasis on active portal and returns to hub", function() {
            var w = test_cbe_world(1);
            var repo = test_cbe_repo("test_cbe_lifecycle_repo_exit");
            var ctl = new PortalLifecycleController(w, repo);

            var pid = ctl.openInSlot("0", "arena_X");
            ctl.enter(pid);

            expect(ctl.exitToHub()).toBeTruthy();
            expect(w.activeContext.inHub).toBeTruthy();
            // activePortalId is kept (controller does not clear on exit)
            expect(string(w.activeContext.activePortalId)).toBe(pid);
            expect(w.portals.get(pid).stasis).toBeTruthy();

            repo.deleteAllSaves();
        });

        test("setDormant marks Dormant, locks slot, and kicks to hub if active", function() {
            var w = test_cbe_world(1);
            var repo = test_cbe_repo("test_cbe_lifecycle_repo_dormant");
            var ctl = new PortalLifecycleController(w, repo);

            var pid = ctl.openInSlot("0", "arena_D");
            ctl.enter(pid);

            expect(ctl.setDormant(pid)).toBeTruthy();
            expect(w.portals.get(pid).state).toBe(PortalState.Dormant);
            expect(w.portals.get(pid).stasis).toBeTruthy();
            expect(w.activeContext.inHub).toBeTruthy();

            var slot = (new PortalSlotService(w)).getSlot("0");
            expect(slot.locked).toBeTruthy();
            expect(slot.portalId).toBe(pid);

            // locked slot cannot be opened
            var pid2 = ctl.openInSlot("0", "arena_NEW");
            expect(pid2).toBe("");

            repo.deleteAllSaves();
        });

        test("closeDestructive unbinds slot, removes portal, deletes file if present", function() {
            var w = test_cbe_world(1);
            var repo = test_cbe_repo("test_cbe_lifecycle_repo_close");
            var ctl = new PortalLifecycleController(w, repo);

            var pid = ctl.openInSlot("0", "arena_Z");
            // Persist a portal file to ensure deletePortal has something to delete.
            repo.writePortalInstance(w.schemaVersion, w.portals.get(pid));

            expect(file_exists("test_cbe_lifecycle_repo_close/portal_" + pid + ".json")).toBeTruthy();

            expect(ctl.closeDestructive(pid)).toBeTruthy();
            expect(test_cbe_has_portal(w, pid)).toBeFalsy();
            expect((new PortalSlotService(w)).getSlot("0").portalId).toBe("");
            expect((new PortalSlotService(w)).getSlot("0").locked).toBeFalsy();

            // File should be gone after deletePortal()
            expect(file_exists("test_cbe_lifecycle_repo_close/portal_" + pid + ".json")).toBeFalsy();

            repo.deleteAllSaves();
        });
    });
}
