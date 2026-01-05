/// GameMaker Testing Library (GMTL) test suites for Bundle A
/// Generated: 20260104231007 UTC
/// Requires: GameMaker Testing Library (GMTL). See tutorial for suite/section/test/expect usage. 
///
/// Conventions:
/// - Each file declares a top-level suite(function(){ ... })
/// - Tests are designed to be deterministic and to clean up files they write.
if (asset_get_index("suite") != -1) suite(function() {
    section("SaveSystem Integration", function() {
        test("saveGame(slot) then loadGame(slot) restores hub + portals + activeContext", function() {
            var repo = test_repo("test_saves_savesystem");
            var ss = new SaveSystem(repo, new SerializerRegistry(), new VersionManager(1), new IntegrityChecker(new Logger()), new FallbackPolicy(), new Logger());

            var w = test_make_world(2);
            expect(ss.saveGame("1", w)).toBeTruthy();

            var loaded = ss.loadGame("1");
            expect(is_undefined(loaded)).toBeFalsy();

            expect(loaded.hub.sharedStorageId).toBe("stash_test");
            expect(loaded.activeContext.inhabitedCharacterId).toBe("e_player");

            var keys = loaded.portals.keys();
            expect(array_length(keys)).toBe(2);

            var p0 = loaded.portals.get("p_0");
            expect(p0.arenaId).toBe("arena_0");

            repo.deleteAllSaves();
        });

        test("loadSnapshot corrupt checksum obeys FallbackPolicy.CreateNew", function() {
            var repo = test_repo("test_saves_corrupt");
            var fp = new FallbackPolicy(CorruptAction.CreateNew, MissingRefAction.SpawnPlaceholder, UnknownTypeAction.StubObject);
            var ss = new SaveSystem(repo, new SerializerRegistry(), new VersionManager(1), new IntegrityChecker(new Logger()), fp, new Logger());

            var w = test_make_world(1);
            var snap = ss.createSnapshot(w);
            repo.writeSnapshot(snap);

            // Corrupt checksum
            var raw = repo.readSnapshot(snap.id);
            raw.checksum = "BAD";
            // overwrite the stored snapshot file by writing the raw struct (repo doesn't expose direct overwrite, so re-use writeSnapshot)
            repo.writeSnapshot(raw);

            var loaded = ss.loadSnapshot(snap.id);
            expect(is_undefined(loaded)).toBeFalsy();
            // CreateNew returns a new WorldState (default hub id empty)
            expect(loaded.hub.sharedStorageId).toBe("");
            repo.deleteAllSaves();
        });

        test("loadGame missing slot + missing hub returns undefined", function() {
            var repo = test_repo("test_saves_missing_slot");
            // Ensure directory exists but no hub/slot files.
            repo.deleteAllSaves();

            var ss = new SaveSystem(repo, new SerializerRegistry(), new VersionManager(1), new IntegrityChecker(new Logger()), new FallbackPolicy(), new Logger());

            var loaded = ss.loadGame("does_not_exist");
            expect(is_undefined(loaded)).toBeTruthy();

            repo.deleteAllSaves();
        });

        test("loadGame slot points to missing snapshot falls back to hub+portals", function() {
            var repo = test_repo("test_saves_missing_snapshot");
            var ss = new SaveSystem(repo, new SerializerRegistry(), new VersionManager(1), new IntegrityChecker(new Logger()), new FallbackPolicy(), new Logger());

            var w = test_make_world(2);
            expect(ss.saveGame("1", w)).toBeTruthy();

            // Delete the snapshot file but keep hub/portal files + slot pointer.
            var _ptr = repo.readSlotPointer("1");
            expect(is_undefined(_ptr)).toBeFalsy();
            var snapPath = "test_saves_missing_snapshot/snapshot_" + string(_ptr.snapshotId) + ".json";
            if (file_exists(snapPath)) file_delete(snapPath);

            var loaded = ss.loadGame("1");
            expect(is_undefined(loaded)).toBeFalsy();
            expect(loaded.hub.sharedStorageId).toBe("stash_test");
            expect(array_length(loaded.portals.keys())).toBe(2);

            repo.deleteAllSaves();
        });

        test("loadSnapshot missing id returns undefined", function() {
            var repo = test_repo("test_saves_missing_snapshot_direct");
            var ss = new SaveSystem(repo, new SerializerRegistry(), new VersionManager(1), new IntegrityChecker(new Logger()), new FallbackPolicy(), new Logger());

            var loaded = ss.loadSnapshot("nope");
            expect(is_undefined(loaded)).toBeTruthy();

            repo.deleteAllSaves();
        });

        test("loadSnapshot corrupt checksum with FallbackPolicy.Reject returns undefined", function() {
            var repo = test_repo("test_saves_corrupt_reject");
            var fp = new FallbackPolicy(CorruptAction.Reject, MissingRefAction.SpawnPlaceholder, UnknownTypeAction.StubObject);
            var ss = new SaveSystem(repo, new SerializerRegistry(), new VersionManager(1), new IntegrityChecker(new Logger()), fp, new Logger());

            var w = test_make_world(1);
            var snap = ss.createSnapshot(w);
            repo.writeSnapshot(snap);

            // Corrupt checksum
            var raw = repo.readSnapshot(snap.id);
            raw.checksum = "BAD";
            repo.writeSnapshot(raw);

            var loaded = ss.loadSnapshot(snap.id);
            expect(is_undefined(loaded)).toBeTruthy();

            repo.deleteAllSaves();
        });
    });
});
