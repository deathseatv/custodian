/// test_CBD_HubNavigation.gml

function test_CBD_HubNavigation() {
    section("Bundle D - HubNavigation", function() {
        test("Defaults to Wisp control", function() {
            var nav = new HubNavigation();
            expect(nav.controlMode == HubControlMode.Wisp).toBeTruthy();
            expect(is_undefined(nav.controlledCharacterId)).toBeTruthy();
            expect(nav.isControlLocked() == false).toBeTruthy();
        });

        test("setCharacterControlled sets mode + char_id", function() {
            var nav = new HubNavigation();
            expect(nav.setCharacterControlled("abc")).toBeTruthy();
            expect(nav.controlMode == HubControlMode.Character).toBeTruthy();
            expect(nav.controlledCharacterId == "abc").toBeTruthy();
        });

        test("lockControl prevents switching", function() {
            var nav = new HubNavigation();
            nav.lockControl();
            expect(nav.isControlLocked()).toBeTruthy();

            // Should refuse changes
            expect(nav.setCharacterControlled("x") == false).toBeTruthy();
            expect(nav.setWispControlled() == false).toBeTruthy();
        });

        test("unlockControl re-allows switching", function() {
            var nav = new HubNavigation();
            nav.lockControl();
            nav.unlockControl();
            expect(nav.isControlLocked() == false).toBeTruthy();
            expect(nav.setCharacterControlled("x")).toBeTruthy();
        });
    });
}
