/// GameMaker Testing Library (GMTL) test suites for Bundle A
/// Generated: 20260104231007 UTC
/// Requires: GameMaker Testing Library (GMTL). See tutorial for suite/section/test/expect usage. 
///
/// Conventions:
/// - Each file declares a top-level suite(function(){ ... })
/// - Tests are designed to be deterministic and to clean up files they write.
if (asset_get_index("suite") != -1) suite(function() {
    section("SnapshotManager", function() {
        test("createSnapshot writes wrapper kind=world", function() {
            var sm = new SnapshotManager(new Logger());
            var w = test_make_world(1);
            var snap = sm.createSnapshot(w);

            var payload = json_parse(snap.payload);
            expect(payload.kind).toBe("world");
            expect(payload.schemaVersion).toBe(w.schemaVersion);
            expect(is_undefined(payload.data.hub)).toBeFalsy();
        });

        test("createHubSnapshot writes wrapper kind=hub", function() {
            var sm = new SnapshotManager(new Logger());
            var w = test_make_world(1);
            var snap = sm.createHubSnapshot(w);

            var payload = json_parse(snap.payload);
            expect(payload.kind).toBe("hub");
            expect(is_undefined(payload.data.hub)).toBeFalsy();
            expect(is_undefined(payload.data.globalState)).toBeFalsy();
        });

        test("createPortalSnapshot writes wrapper kind=portal", function() {
            var sm = new SnapshotManager(new Logger());
            var w = test_make_world(2);
            var snap = sm.createPortalSnapshot(w, "p_1");

            var payload = json_parse(snap.payload);
            expect(payload.kind).toBe("portal");
            expect(payload.data.portalId).toBe("p_1");
            expect(payload.data.portal.portalId).toBe("p_1");
        });
    });
});
