/// GameMaker Testing Library (GMTL) test suites for Bundle A
/// Generated: 20260104231007 UTC
/// Requires: GameMaker Testing Library (GMTL). See tutorial for suite/section/test/expect usage. 
///
/// Conventions:
/// - Each file declares a top-level suite(function(){ ... })
/// - Tests are designed to be deterministic and to clean up files they write.
if (asset_get_index("suite") != -1) suite(function() {
    section("PersistenceRepository", function() {
        test("Snapshot write/read roundtrip", function() {
            var repo = test_repo("test_saves_repo");

            var payload = "{\"x\":1}";
            var snap = Snapshot_CreateFromPayload(payload, 1);
            expect(repo.writeSnapshot(snap)).toBeTruthy();

            var read = repo.readSnapshot(snap.id);
            expect(is_undefined(read)).toBeFalsy();
            expect(read.id).toBe(snap.id);
            expect(read.payload).toBe(payload);
            expect(read.schemaVersion).toBe(1);

            repo.deleteAllSaves();
        });

        test("Slot pointer write/read + listSaveSlots", function() {
            var repo = test_repo("test_saves_repo_slots");

            var snap = Snapshot_CreateFromPayload("{\"ok\":true}", 1);
            repo.writeSnapshot(snap);
            expect(repo.writeSlotPointer("A", snap)).toBeTruthy();

            var slotPtr = repo.readSlotPointer("A");
            expect(is_undefined(slotPtr)).toBeFalsy();
            expect(slotPtr.snapshotId).toBe(snap.id);

            var slots = repo.listSaveSlots();
            // Ensure "A" is present
            var found = false;
            for (var i = 0; i < array_length(slots); i++) if (slots[i] == "A") found = true;
            expect(found).toBeTruthy();

            repo.deleteAllSaves();
        });

        test("Hub persistence write/read", function() {
            var repo = test_repo("test_saves_repo_hub");

            var w = test_make_world(1);
            expect(repo.writeHub(w.schemaVersion, w.hub, w.activeContext, w.globalState)).toBeTruthy();

            var hubObj = repo.readHub();
            expect(is_undefined(hubObj)).toBeFalsy();
            expect(hubObj.schemaVersion).toBe(w.schemaVersion);
            expect(hubObj.hub.sharedStorageId).toBe("stash_test");
            expect(hubObj.activeContext.inhabitedCharacterId).toBe("e_player");

            repo.deleteAllSaves();
        });

        test("Portal instance persistence write/read + listPortals", function() {
            var repo = test_repo("test_saves_repo_portals");
            var w = test_make_world(2);

            var ids = w.portals.keys();
            for (var i = 0; i < array_length(ids); i++) {
                var inst = w.portals.get(ids[i]);
                repo.writePortalInstance(w.schemaVersion, inst);
            }

            var portalIds = repo.listPortals();
            expect(array_length(portalIds)).toBe(2);

            var p0 = repo.readPortalInstance("p_0");
            expect(is_undefined(p0)).toBeFalsy();
            expect(p0.portal.portalId).toBe("p_0");
            expect(p0.portal.arenaId).toBe("arena_0");

            repo.deleteAllSaves();
        });

        test("readHub missing returns undefined (no crash)", function() {
            var repo = test_repo("test_saves_repo_missing_hub");
            repo.deleteAllSaves();

            var hubObj = repo.readHub();
            expect(is_undefined(hubObj)).toBeTruthy();

            repo.deleteAllSaves();
        });

        test("listPortals empty when none exist", function() {
            var repo = test_repo("test_saves_repo_empty_portals");
            repo.deleteAllSaves();

            var portalIds = repo.listPortals();
            expect(array_length(portalIds)).toBe(0);

            repo.deleteAllSaves();
        });

        test("readHub invalid JSON throws (caller must handle)", function() {
            var repo = test_repo("test_saves_repo_invalid_json");
            repo.deleteAllSaves();

            // Write an invalid hub.json payload.
            var f = file_text_open_write("test_saves_repo_invalid_json/hub.json");
            file_text_write_string(f, "{ this is not valid json ");
            file_text_close(f);

            var threw = false;
            try {
                var _ = repo.readHub();
            } catch (e) {
                threw = true;
            }
            expect(threw).toBeTruthy();

            repo.deleteAllSaves();
        });
    });
});
