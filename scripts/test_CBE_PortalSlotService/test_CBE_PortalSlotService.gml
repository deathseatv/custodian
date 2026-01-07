/// test_CBE_PortalSlotService.gml
/// Bundle E - PortalSlotService behaviors
/// Generated: 20260107143348 UTC

function test_CBE_PortalSlotService() {
    section("PortalSlotService", function() {
        test("bindPortal ensures slot exists and binds id", function() {
            var w = test_cbe_world(1);
            var svc = new PortalSlotService(w);

            expect(svc.bindPortal("0", "p_abc")).toBeTruthy();
            var slot = svc.getSlot("0");
            expect(slot.portalId).toBe("p_abc");
            expect(slot.locked).toBeFalsy();
        });

        test("lock/unlock and clearSlot", function() {
            var w = test_cbe_world(1);
            var svc = new PortalSlotService(w);
            svc.bindPortal("0", "p_1");

            expect(svc.lockSlot("0")).toBeTruthy();
            expect(svc.getSlot("0").locked).toBeTruthy();

            expect(svc.unlockSlot("0")).toBeTruthy();
            expect(svc.getSlot("0").locked).toBeFalsy();

            expect(svc.clearSlot("0")).toBeTruthy();
            expect(svc.getSlot("0").portalId).toBe("");
            expect(svc.getSlot("0").locked).toBeFalsy();
        });

        test("findSlotIdByPortal returns slot id", function() {
            var w = test_cbe_world(2);
            var svc = new PortalSlotService(w);
            svc.bindPortal("1", "p_findme");

            expect(svc.findSlotIdByPortal("p_findme")).toBe("1");
            expect(svc.findSlotIdByPortal("p_missing")).toBe("");
        });
    });
}
