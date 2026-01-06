/// test_CBD_suite.gml
/// Aggregate entry point. If your GMTL init enumerates tests automatically by naming convention,
/// this file is still safe. Otherwise, call test_CBD_suite() from your test bootstrap.

suite(function test_CBD_suite() {
    // Order: helpers are separate script file, loaded automatically by GMS.
    test_CBD_smoke();
    test_CBD_HubNavigation();
    test_CBD_CharacterLifecycleService();
    test_CBD_LifeSystem();
    test_CBD_InhabitationService();
    test_CBD_RetirementService();
    test_CBD_EntityRegistry_Serialization();
    test_CBD_HubController();
});
