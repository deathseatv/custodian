/// test_CBE_PortalSlotState.gml
/// Bundle E - PortalSlotState serialization + normalization
/// Generated: 20260107143348 UTC

function test_CBE_PortalSlotState() {
    section("PortalSlotState", function() {
        test("toStruct / FromStruct roundtrip", function() {
            var s0 = new PortalSlotState("slotA");
            s0.portalId = "p_test";
            s0.locked = true;

            var st = s0.toStruct();
            var s1 = PortalSlotState_FromStruct(st);

            expect(s1.slotId).toBe("slotA");
            expect(s1.portalId).toBe("p_test");
            expect(s1.locked).toBeTruthy();
        });

        test("PortalSlots_EnsureCount grows and normalizes legacy entries", function() {
            var hub = new HubState();
            hub.portalSlots = ["0", "1"]; // legacy style (strings)

            expect(PortalSlots_EnsureCount(hub, 3)).toBeTruthy();
            expect(array_length(hub.portalSlots)).toBe(3);

            // Normalized into PortalSlotState structs
            expect(is_struct(hub.portalSlots[0])).toBeTruthy();
            expect(hub.portalSlots[0].slotId).toBe("0");
            expect(hub.portalSlots[1].slotId).toBe("1");
            expect(hub.portalSlots[2].slotId).toBe("2");
        });
    });
}
