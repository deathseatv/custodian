/// test_CBD_CharacterLifecycleService.gml

function test_CBD_CharacterLifecycleService() {
    section("Bundle D - CharacterLifecycleService", function() {
        var E = _test_CBD_getLifeEnum();
        test("createCharacter registers entity + adds to hub list + sets INACTIVE", function() {
        var E = _test_CBD_getLifeEnum();
            var w = _test_CBD_makeWorld();
            var svc = new CharacterLifecycleService(w);

            var char_id = svc.createCharacter("Test", "p1", "sword", 3);
            expect(!is_undefined(char_id)).toBeTruthy();
            expect(is_array(w.hub.entities)).toBeTruthy();
            expect(array_length(w.hub.entities) > 0).toBeTruthy();

            // Entity exists
            var e = _test_CBD_getEntity(w, char_id);
            expect(!is_undefined(e)).toBeTruthy();

            // Components exist by type char_id used by CBD components
            expect(_test_CBD_hasComponent(e, "character")).toBeTruthy();
            expect(_test_CBD_hasComponent(e, "life")).toBeTruthy();
            expect(_test_CBD_hasComponent(e, "hub_presence")).toBeTruthy();

            // State stored on character component data
            expect(svc.getState(char_id) == E.INACTIVE).toBeTruthy();
        });

        test("setState updates and getState returns updated value", function() {
        var E = _test_CBD_getLifeEnum();
            var w = _test_CBD_makeWorld();
            var svc = new CharacterLifecycleService(w);

            var char_id = svc.createCharacter("Test", "p1", "sword", 1);
            expect(svc.setState(char_id, E.ACTIVE)).toBeTruthy();
            expect(svc.getState(char_id) == E.ACTIVE).toBeTruthy();
        });

        test("isPlayable true for ACTIVE/INACTIVE, false for DEAD/RETIRED", function() {
        var E = _test_CBD_getLifeEnum();
            var w = _test_CBD_makeWorld();
            var svc = new CharacterLifecycleService(w);

            var char_id = svc.createCharacter("Test", "p1", "sword", 1);

            svc.setState(char_id, E.INACTIVE);
            expect(svc.isPlayable(char_id)).toBeTruthy();

            svc.setState(char_id, E.ACTIVE);
            expect(svc.isPlayable(char_id)).toBeTruthy();

            svc.setState(char_id, E.DEAD);
            expect(svc.isPlayable(char_id) == false).toBeTruthy();

            svc.setState(char_id, E.RETIRED);
            expect(svc.isPlayable(char_id) == false).toBeTruthy();
        });
    });
}
