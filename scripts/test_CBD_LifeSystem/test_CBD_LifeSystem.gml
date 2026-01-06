/// test_CBD_LifeSystem.gml

function test_CBD_LifeSystem() {
    section("Bundle D - LifeSystem", function() {
        var E = _test_CBD_getLifeEnum();
        test("getLives returns starting max lives", function() {
        var E = _test_CBD_getLifeEnum();
            var w = _test_CBD_makeWorld();
            var lifecycle = new CharacterLifecycleService(w);
            var life = new LifeSystem(w, lifecycle);

            var char_id = lifecycle.createCharacter("Test", "p1", "sword", 4);
            expect(life.getLives(char_id) == 4).toBeTruthy();
            expect(life.isOutOfLives(char_id) == false).toBeTruthy();
        });

        test("consumeLifeOnDeath decrements and sets INACTIVE if remaining > 0", function() {
        var E = _test_CBD_getLifeEnum();
            var w = _test_CBD_makeWorld();
            var lifecycle = new CharacterLifecycleService(w);
            var life = new LifeSystem(w, lifecycle);

            var char_id = lifecycle.createCharacter("Test", "p1", "sword", 2);
            lifecycle.setState(char_id, E.ACTIVE);

            expect(life.consumeLifeOnDeath(char_id)).toBeTruthy();
            expect(life.getLives(char_id) == 1).toBeTruthy();
            expect(lifecycle.getState(char_id) == E.INACTIVE).toBeTruthy();
        });

        test("consumeLifeOnDeath sets DEAD at 0 lives and clamps at 0", function() {
        var E = _test_CBD_getLifeEnum();
            var w = _test_CBD_makeWorld();
            var lifecycle = new CharacterLifecycleService(w);
            var life = new LifeSystem(w, lifecycle);

            var char_id = lifecycle.createCharacter("Test", "p1", "sword", 1);
            lifecycle.setState(char_id, E.ACTIVE);

            expect(life.consumeLifeOnDeath(char_id)).toBeTruthy();
            expect(life.getLives(char_id) == 0).toBeTruthy();
            expect(lifecycle.getState(char_id) == E.DEAD).toBeTruthy();
            expect(life.isOutOfLives(char_id)).toBeTruthy();

            // Consume again should remain 0
            expect(life.consumeLifeOnDeath(char_id)).toBeTruthy();
            expect(life.getLives(char_id) == 0).toBeTruthy();
            expect(lifecycle.getState(char_id) == E.DEAD).toBeTruthy();
        });
    });
}
