/// test_CBD_smoke.gml
/// Presence + basic construction tests for Bundle D.

function test_CBD_smoke() {
    section("Bundle D - Smoke / Presence", function() {
        test("Constructors exist (Bundle D)", function() {
            expect(!is_undefined(HubController)).toBeTruthy();
            expect(!is_undefined(HubNavigation)).toBeTruthy();
            expect(!is_undefined(CharacterLifecycleService)).toBeTruthy();
            expect(!is_undefined(LifeSystem)).toBeTruthy();
            expect(!is_undefined(InhabitationService)).toBeTruthy();
            expect(!is_undefined(RetirementService)).toBeTruthy();
            expect(!is_undefined(CharacterGallery)).toBeTruthy();
            expect(!is_undefined(HubUI)).toBeTruthy();
        });

        test("Enums exist (Bundle D)", function() {
            var E = _test_CBD_getLifeEnum();
            expect(!is_undefined(E)).toBeTruthy();
            expect(!is_undefined(HubControlMode)).toBeTruthy();

            // Ensure enum members exist
            expect(!is_undefined(CharacterLifeState.INACTIVE)).toBeTruthy();
            expect(!is_undefined(CharacterLifeState.ACTIVE)).toBeTruthy();
            expect(!is_undefined(CharacterLifeState.DEAD)).toBeTruthy();
            expect(!is_undefined(CharacterLifeState.RETIRED)).toBeTruthy();

            expect(!is_undefined(HubControlMode.Wisp)).toBeTruthy();
            expect(!is_undefined(HubControlMode.Character)).toBeTruthy();
        });
    });
}
