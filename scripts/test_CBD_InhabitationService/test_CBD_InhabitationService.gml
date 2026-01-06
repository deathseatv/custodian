/// test_CBD_InhabitationService.gml

function test_CBD_InhabitationService() {
    section("Bundle D - InhabitationService", function() {
        var E = _test_CBD_getLifeEnum();
        test("requestInhabit returns true for INACTIVE/ACTIVE and sets prompt", function() {
        var E = _test_CBD_getLifeEnum();
            var w = _test_CBD_makeWorld();
            var nav = new HubNavigation();
            var ui = new HubUI();
            var lifecycle = new CharacterLifecycleService(w);
            var inhab = new InhabitationService(w, nav, lifecycle, ui);

            var char_id = lifecycle.createCharacter("Test", "p1", "sword", 2);
            lifecycle.setState(char_id, E.INACTIVE);

            expect(inhab.requestInhabit(char_id)).toBeTruthy();

            // HubUI stores last prompts (CBD_HubUI implementation)
            expect(ui.lastInhabitPromptId == string(char_id)).toBeTruthy();
        });

        test("confirmInhabit sets activeContext.inhabitedCharacterId and nav mode and lifecycle ACTIVE", function() {
        var E = _test_CBD_getLifeEnum();
            var w = _test_CBD_makeWorld();
            var nav = new HubNavigation();
            var ui = new HubUI();
            var lifecycle = new CharacterLifecycleService(w);
            var inhab = new InhabitationService(w, nav, lifecycle, ui);

            var char_id = lifecycle.createCharacter("Test", "p1", "sword", 2);
            lifecycle.setState(char_id, E.INACTIVE);

            expect(inhab.confirmInhabit(char_id)).toBeTruthy();
            expect(w.activeContext.inhabitedCharacterId == string(char_id)).toBeTruthy();
            expect(nav.controlMode == HubControlMode.Character).toBeTruthy();
            expect(nav.controlledCharacterId == string(char_id)).toBeTruthy();
            expect(lifecycle.getState(char_id) == E.ACTIVE).toBeTruthy();
        });

        test("uninhabit clears activeContext.inhabitedCharacterId and sets wisp control", function() {
        var E = _test_CBD_getLifeEnum();
            var w = _test_CBD_makeWorld();
            var nav = new HubNavigation();
            var ui = new HubUI();
            var lifecycle = new CharacterLifecycleService(w);
            var inhab = new InhabitationService(w, nav, lifecycle, ui);

            var char_id = lifecycle.createCharacter("Test", "p1", "sword", 2);
            inhab.confirmInhabit(char_id);

            expect(inhab.uninhabit()).toBeTruthy();
            expect(is_undefined(w.activeContext.inhabitedCharacterId)).toBeTruthy();
            expect(nav.controlMode == HubControlMode.Wisp).toBeTruthy();
            expect(is_undefined(nav.controlledCharacterId)).toBeTruthy();
        });

        test("cannot inhabit DEAD/RETIRED", function() {
        var E = _test_CBD_getLifeEnum();
            var w = _test_CBD_makeWorld();
            var nav = new HubNavigation();
            var ui = new HubUI();
            var lifecycle = new CharacterLifecycleService(w);
            var inhab = new InhabitationService(w, nav, lifecycle, ui);

            var char_id = lifecycle.createCharacter("Test", "p1", "sword", 1);

            lifecycle.setState(char_id, E.DEAD);
            expect(inhab.canInhabit(char_id) == false).toBeTruthy();
            expect(inhab.requestInhabit(char_id) == false).toBeTruthy();

            lifecycle.setState(char_id, E.RETIRED);
            expect(inhab.canInhabit(char_id) == false).toBeTruthy();
        });
    });
}
