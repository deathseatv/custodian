/// GameMaker Testing Library (GMTL) test suites for Bundle A
/// Generated: 20260104231007 UTC
/// Requires: GameMaker Testing Library (GMTL). See tutorial for suite/section/test/expect usage. 
///
/// Conventions:
/// - Each file declares a top-level suite(function(){ ... })
/// - Tests are designed to be deterministic and to clean up files they write.
if (asset_get_index("suite") != -1) suite(function() {
    section("IntegrityChecker", function() {
        test("validate detects duplicate entity IDs across hub and portals", function() {
            var checker = new IntegrityChecker(new Logger());
            var w = test_make_world(1);

            // Create duplicate ids: hub contains "dup", portal contains "dup"
            w.hub.entities = ["dup"];
            var inst = w.portals.get("p_0");
            inst.entities = ["dup"];

            var report = checker.validate(w);
            expect(report.ok).toBeFalsy();
            // Should contain at least one error
            expect(array_length(report.errors)).toBeGreaterThan(0);
        });

        test("validateSnapshot detects checksum mismatch", function() {
            var checker = new IntegrityChecker(new Logger());
            var snap = Snapshot_CreateFromPayload("{\"a\":1}", 1);
            snap.checksum = "BAD";
            var report = checker.validateSnapshot(snap);
            expect(report.ok).toBeFalsy();
            expect(array_length(report.errors)).toBeGreaterThan(0);
        });
    });
});
