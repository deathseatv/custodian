/// GameMaker Testing Library (GMTL) test suites for Bundle A
/// Generated: 20260104231007 UTC
/// Requires: GameMaker Testing Library (GMTL). See tutorial for suite/section/test/expect usage. 
///
/// Conventions:
/// - Each file declares a top-level suite(function(){ ... })
/// - Tests are designed to be deterministic and to clean up files they write.
if (asset_get_index("suite") != -1) suite(function() {
    section("DebugConsole", function() {
        test("resetSave deletes artifacts (when repo supports deleteAllSaves)", function() {
            var repo = test_repo("test_saves_debugconsole");
            var ss = new SaveSystem(repo, new SerializerRegistry(), new VersionManager(1), new IntegrityChecker(new Logger()), new FallbackPolicy(), new Logger());

            var w = test_make_world(1);
            ss.saveGame("1", w);

            var tools = new DebugTools(repo, ss.snapshots, new Logger());
            var console = new DebugConsole(ss, tools, new TestDataFactory(), new Logger());
            expect(console.resetSave()).toBeTruthy();

            // After reset, hub should not exist and no slots should exist
            var slots = repo.listSaveSlots();
            expect(array_length(slots)).toBe(0);

            repo.deleteAllSaves();
        });
    });
});
