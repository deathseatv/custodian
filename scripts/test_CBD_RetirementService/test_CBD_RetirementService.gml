/// test_CBD_RetirementService.gml

function test_CBD_RetirementService() {
    section("Bundle D - RetirementService", function() {
        var E = _test_CBD_getLifeEnum();
        test("canRetire true when DEAD or out of lives", function() {
        var E = _test_CBD_getLifeEnum();
            var w = _test_CBD_makeWorld();
            var lifecycle = new CharacterLifecycleService(w);
            var life = new LifeSystem(w, lifecycle);
            var nav = new HubNavigation();
            var ui = new HubUI();
            var inhab = new InhabitationService(w, nav, lifecycle, ui);
            var retire = new RetirementService(w, lifecycle, life, inhab, ui);

            var char_id = lifecycle.createCharacter("Test", "p1", "sword", 1);

            lifecycle.setState(char_id, E.DEAD);
            expect(retire.canRetire(char_id)).toBeTruthy();

            // Also by out-of-lives path (even if state not DEAD yet)
            lifecycle.setState(char_id, E.ACTIVE);
            // consume to 0 lives, should set DEAD via LifeSystem but still counts
            life.consumeLifeOnDeath(char_id);
            expect(life.isOutOfLives(char_id)).toBeTruthy();
            expect(retire.canRetire(char_id)).toBeTruthy();
        });

        test("retire sets RETIRED and emits retire prompt", function() {
        var E = _test_CBD_getLifeEnum();
            var w = _test_CBD_makeWorld();
            var lifecycle = new CharacterLifecycleService(w);
            var life = new LifeSystem(w, lifecycle);
            var nav = new HubNavigation();
            var ui = new HubUI();
            var inhab = new InhabitationService(w, nav, lifecycle, ui);
            var retire = new RetirementService(w, lifecycle, life, inhab, ui);

            var char_id = lifecycle.createCharacter("Test", "p1", "sword", 1);
            lifecycle.setState(char_id, E.DEAD);

            expect(retire.retire(char_id)).toBeTruthy();
            expect(lifecycle.getState(char_id) == E.RETIRED).toBeTruthy();
            expect(ui.lastRetirePromptId == string(char_id)).toBeTruthy();
        });

        test("retire uninhabits if currently inhabited", function() {
        var E = _test_CBD_getLifeEnum();
            var w = _test_CBD_makeWorld();
            var lifecycle = new CharacterLifecycleService(w);
            var life = new LifeSystem(w, lifecycle);
            var nav = new HubNavigation();
            var ui = new HubUI();
            var inhab = new InhabitationService(w, nav, lifecycle, ui);
            var retire = new RetirementService(w, lifecycle, life, inhab, ui);

            var char_id = lifecycle.createCharacter("Test", "p1", "sword", 1);
            inhab.confirmInhabit(char_id);

            lifecycle.setState(char_id, E.DEAD);
            expect(w.activeContext.inhabitedCharacterId == string(char_id)).toBeTruthy();

            expect(retire.retire(char_id)).toBeTruthy();
            expect(is_undefined(w.activeContext.inhabitedCharacterId)).toBeTruthy();
            expect(nav.controlMode == HubControlMode.Wisp).toBeTruthy();
        });

        test("cannot retire if INACTIVE/ACTIVE with lives remaining", function() {
        var E = _test_CBD_getLifeEnum();
            var w = _test_CBD_makeWorld();
            var lifecycle = new CharacterLifecycleService(w);
            var life = new LifeSystem(w, lifecycle);
            var nav = new HubNavigation();
            var ui = new HubUI();
            var inhab = new InhabitationService(w, nav, lifecycle, ui);
            var retire = new RetirementService(w, lifecycle, life, inhab, ui);

            var char_id = lifecycle.createCharacter("Test", "p1", "sword", 2);
            lifecycle.setState(char_id, E.INACTIVE);

            expect(retire.canRetire(char_id) == false).toBeTruthy();
            expect(retire.retire(char_id) == false).toBeTruthy();
            expect(ui.lastErrorMessage == "Cannot retire this character.").toBeTruthy();
        });
    });
}
