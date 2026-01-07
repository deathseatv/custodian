/// test_CBE_integration_SaveSystem.gml
/// Bundle E integration: SaveSystem should persist portalSlots + portal states
/// Generated: 20260107143348 UTC

function test_CBE_integration_SaveSystem() {
    section("Integration: SaveSystem", function() {
        test("SaveGame/LoadGame preserves slot binding + portal stasis/state", function() {
            var repo = test_cbe_repo("test_cbe_integr_save_repo");
            var save = new SaveSystem(repo);

            var w = test_cbe_world(1);
            var ctl = new PortalLifecycleController(w, repo);

            var pid = ctl.openInSlot("0", "arena_S");
            ctl.enter(pid);
            ctl.exitToHub(); // should set stasis true

            // mark dormant too
            ctl.setDormant(pid);

            expect(save.saveGame(0, w)).toBeTruthy();

            var w2 = save.loadGame(0);
            expect(is_undefined(w2)).toBeFalsy();
            expect(is_undefined(w2.hub)).toBeFalsy();
            expect(is_array(w2.hub.portalSlots)).toBeTruthy();
            expect(array_length(w2.hub.portalSlots)).toBe(1);

            var slot = w2.hub.portalSlots[0];
            expect(is_struct(slot)).toBeTruthy();
            expect(slot.slotId).toBe("0");
            expect(slot.portalId).toBe(pid);
            expect(slot.locked).toBeTruthy();

            expect(w2.portals.has(pid)).toBeTruthy();
            var p = w2.portals.get(pid);
            expect(p.state).toBe(PortalState.Dormant);
            expect(p.stasis).toBeTruthy();
            expect(p.arenaId).toBe("arena_S");

            repo.deleteAllSaves();
        });
    });
}
