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
                if (!variable_struct_exists(bundle.world, "globalState") || is_undefined(bundle.world.globalState) || !is_struct(bundle.world.globalState)) bundle.world.globalState = {};
                bundle.world.globalState.migrated = true;
                return bundle;
            });
            vm.addStep(step);

            var bundle = { schemaVersion: 1, world: test_make_world(1).toStruct() };
            // Remove globalState to simulate old snapshot
            if (variable_struct_exists(bundle.world, "globalState")) struct_remove(bundle.world, "globalState");

            var migrated = vm.migrate(bundle);
            expect(migrated.schemaVersion).toBe(2);
            expect(migrated.world.globalState.migrated).toBeTruthy();
        });

        test("migrate applies multi-step forward migrations in order (1->2->3)", function() {
            var vm = new VersionManager(3);

            var step12 = new MigrationStep(1, 2, function(bundle) {
                if (!variable_struct_exists(bundle.world, "globalState") || is_undefined(bundle.world.globalState) || !is_struct(bundle.world.globalState)) bundle.world.globalState = {};
                bundle.world.globalState.step12 = true;
                return bundle;
            });
            var step23 = new MigrationStep(2, 3, function(bundle) {
                if (!variable_struct_exists(bundle.world, "globalState") || is_undefined(bundle.world.globalState) || !is_struct(bundle.world.globalState)) bundle.world.globalState = {};
                bundle.world.globalState.step23 = true;
                return bundle;
            });

            vm.addStep(step12);
            vm.addStep(step23);

            var bundle = { schemaVersion: 1, world: test_make_world(1).toStruct() };
            if (variable_struct_exists(bundle.world, "globalState")) struct_remove(bundle.world, "globalState");

            var migrated = vm.migrate(bundle);
            expect(migrated.schemaVersion).toBe(3);
            expect(migrated.world.globalState.step12).toBeTruthy();
            expect(migrated.world.globalState.step23).toBeTruthy();
        });

        test("migrate stops when a required step is missing (no path)", function() {
            var vm = new VersionManager(3);
            var step12 = new MigrationStep(1, 2, function(bundle) {
                if (!variable_struct_exists(bundle.world, "globalState") || is_undefined(bundle.world.globalState) || !is_struct(bundle.world.globalState)) bundle.world.globalState = {};
                bundle.world.globalState.only12 = true;
                return bundle;
            });
            vm.addStep(step12);

            var bundle = { schemaVersion: 1, world: test_make_world(1).toStruct() };
            if (variable_struct_exists(bundle.world, "globalState")) struct_remove(bundle.world, "globalState");

            var migrated = vm.migrate(bundle);
            // Current is 3, but we only had 1->2, so it should stop at 2.
            expect(migrated.schemaVersion).toBe(2);
            expect(migrated.world.globalState.only12).toBeTruthy();
            // step23 flag should not exist
            expect(variable_struct_exists(migrated.world.globalState, "step23")).toBeFalsy();
        });

        test("migrate is a no-op when already at current schemaVersion", function() {
            var vm = new VersionManager(2);
            var step = new MigrationStep(1, 2, function(bundle) {
                // If this runs unexpectedly, it would stamp a flag.
                if (!variable_struct_exists(bundle.world, "globalState") || is_undefined(bundle.world.globalState) || !is_struct(bundle.world.globalState)) bundle.world.globalState = {};
                bundle.world.globalState.shouldNotRun = true;
                return bundle;
            });
            vm.addStep(step);

            var bundle = { schemaVersion: 2, world: test_make_world(1).toStruct() };
            var migrated = vm.migrate(bundle);
            expect(migrated.schemaVersion).toBe(2);
            expect(variable_struct_exists(migrated.world.globalState, "shouldNotRun")).toBeFalsy();
        });
    });
});
