/// test_CBD_EntityRegistry_Serialization.gml
/// Covers EntityRegistry_ToStruct / EntityRegistry_FromStruct integration.

function test_CBD_EntityRegistry_Serialization() {
    section("Bundle D - EntityRegistry Serialization", function() {
        test("ToStruct returns [] for missing/invalid registry", function() {
            expect(is_array(EntityRegistry_ToStruct(undefined))).toBeTruthy();
            expect(array_length(EntityRegistry_ToStruct(undefined)) == 0).toBeTruthy();
        });

        test("Roundtrip preserves entity count and ids (registry add/get available)", function() {
            var w = _test_CBD_makeWorld();
            var reg = w.entityRegistry;

            // Create two entities in the same way CBD does
            var e1 = new Entity(undefined, "character");
            e1.addComponent(CharacterComponent_Create("A", "p", "sword"));
            e1.addComponent(LifeComponent_Create(2));
            reg.add(e1);

            var e2 = new Entity(undefined, "character");
            e2.addComponent(CharacterComponent_Create("B", "p", "axe"));
            e2.addComponent(LifeComponent_Create(3));
            reg.add(e2);

            var arr = EntityRegistry_ToStruct(reg);
            expect(is_array(arr)).toBeTruthy();
            expect(array_length(arr) == 2).toBeTruthy();

            var reg2 = EntityRegistry_FromStruct(arr);
            // If get() exists, verify ids resolve
            if (is_struct(reg2) && variable_struct_exists(reg2, "get")) {
                expect(!is_undefined(reg2.get(e1.id))).toBeTruthy();
                expect(!is_undefined(reg2.get(e2.id))).toBeTruthy();
            }
        });

        test("WorldState.toStruct includes entities and WorldState_FromStruct restores them", function() {
            var w = _test_CBD_makeWorld();
            var lifecycle = new CharacterLifecycleService(w);
            var char_id = lifecycle.createCharacter("A", "p", "sword", 2);

            var s = w.toStruct();
            expect(is_struct(s)).toBeTruthy();
            expect(variable_struct_exists(s, "entities")).toBeTruthy();
            expect(is_array(s.entities)).toBeTruthy();
            expect(array_length(s.entities) >= 1).toBeTruthy();

            var w2 = WorldState_FromStruct(s, w.schemaVersion);
            expect(!is_undefined(w2.entityRegistry)).toBeTruthy();

            if (is_struct(w2.entityRegistry) && variable_struct_exists(w2.entityRegistry, "get")) {
                expect(!is_undefined(w2.entityRegistry.get(char_id))).toBeTruthy();
            }
        });

        test("WorldState_FromStruct tolerates missing entities field (older saves)", function() {
            var w = _test_CBD_makeWorld();
            var s = w.toStruct();

            // Remove entities key if present
            if (variable_struct_exists(s, "entities")) {
                variable_struct_remove(s, "entities");
            }

            var w2 = WorldState_FromStruct(s, w.schemaVersion);
            expect(!is_undefined(w2)).toBeTruthy();
            expect(!is_undefined(w2.entityRegistry)).toBeTruthy();
        });
    });
}
