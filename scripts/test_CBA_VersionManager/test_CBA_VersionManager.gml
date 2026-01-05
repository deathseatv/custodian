/// GameMaker Testing Library (GMTL) test suites for Bundle A
/// Generated: 20260104231007 UTC
/// Requires: GameMaker Testing Library (GMTL). See tutorial for suite/section/test/expect usage. 
///
/// Conventions:
/// - Each file declares a top-level suite(function(){ ... })
/// - Tests are designed to be deterministic and to clean up files they write.
if (asset_get_index("suite") != -1) suite(function() {
    section("VersionManager", function() {
        test("migrate applies forward step 1->2", function() {
            var vm = new VersionManager(2);

            // Migration: ensure globalState exists and add a migrated flag.
            var step = new MigrationStep(1, 2, function(bundle) {
                if (!variable_struct_exists(bundle.world, "globalState")) bundle.world.globalState = {};
                bundle.world.globalState.migrated = true;
                return bundle;
            });
            vm.addStep(step);

            var bundle = { schemaVersion: 1, world: test_make_world(1).toStruct() };
            // Remove globalState to simulate old snapshot
            if (variable_struct_exists(bundle.world, "globalState")) bundle.world.globalState = undefined;

            var migrated = vm.migrate(bundle);
            expect(migrated.schemaVersion).toBe(2);
            expect(migrated.world.globalState.migrated).toBeTruthy();
        });
    });
});
