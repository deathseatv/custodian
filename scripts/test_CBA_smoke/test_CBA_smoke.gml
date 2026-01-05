/// GameMaker Testing Library (GMTL) test suites for Bundle A
/// Generated: 20260104231007 UTC
/// Requires: GameMaker Testing Library (GMTL). See tutorial for suite/section/test/expect usage. 
///
/// Conventions:
/// - Each file declares a top-level suite(function(){ ... })
/// - Tests are designed to be deterministic and to clean up files they write.
if (asset_get_index("suite") != -1) suite(function() {
    section("Bundle A - Smoke / Presence", function() {
        test("Constructors exist (* and core types)", function() {
            // If any of these fail, Bundle A code is not imported/compiled.
            expect(is_callable(SaveSystem)).toBeTruthy();
            expect(is_callable(PersistenceRepository)).toBeTruthy();
            expect(is_callable(SnapshotManager)).toBeTruthy();
            expect(is_callable(WorldState)).toBeTruthy();
            expect(is_callable(HubState)).toBeTruthy();
            expect(is_callable(PortalRegistryState)).toBeTruthy();
            expect(is_callable(PortalInstanceState)).toBeTruthy();
            expect(is_callable(VersionManager)).toBeTruthy();
            expect(is_callable(MigrationStep)).toBeTruthy();
            expect(is_callable(IntegrityChecker)).toBeTruthy();
            expect(is_callable(IntegrityReport)).toBeTruthy();
            expect(is_callable(FallbackPolicy)).toBeTruthy();
            expect(is_callable(Snapshot)).toBeTruthy();
            expect(is_callable(Logger)).toBeTruthy();
        });
    });
});
