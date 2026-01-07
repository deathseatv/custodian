/// test_CBE_suite.gml
/// Bundle E comprehensive suite aggregator
/// Generated: 20260107143348 UTC

suite(function test_CBE_suite() {
    // Ensure helpers script is present (loaded automatically by GMS)
    test_CBE_smoke();
    test_CBE_PortalSlotState();
    test_CBE_PortalSlotService();
    test_CBE_PortalLifecycleController();
    test_CBE_integration_SaveSystem();
    test_CBE_integration_HubController();
});
