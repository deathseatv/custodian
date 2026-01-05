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

    section("Serialization", function() {
        test("EntitySerializer roundtrip preserves id/type/components", function() {
            var e = new Entity("e_1", "player");
            e.addComponent(new Component("Stats", { hp: 10, mp: 5 }));
            e.addComponent(new Component("Tags", { elite: false }));

            var ser = new EntitySerializer();
            var bytes = ser.serialize(e);
            var e2 = ser.deserialize(bytes);

            expect(e2.id).toBe("e_1");
            expect(e2.typeId).toBe("player");
            expect(array_length(e2.components)).toBe(2);
            expect(e2.getComponent("Stats").data.hp).toBe(10);
            expect(e2.getComponent("Stats").data.mp).toBe(5);
            expect(e2.getComponent("Tags").data.elite).toBeFalsy();
        });

        test("SerializerRegistry register/get works for valid serializer", function() {
            var reg = new SerializerRegistry();
            var ok = reg.register("Entity", new EntitySerializer());
            expect(ok).toBeTruthy();
            expect(is_undefined(reg.get("Entity"))).toBeFalsy();
            reg.destroy();
        });
    });
});
