/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Updated for Bundle E slot structs
///
/// NOTE:
/// - hub.portalSlots is now an array of PortalSlotState (Bundle E).
/// - Backward compatible: older saves that stored string slot ids are normalized.

/// @desc Shared hub state.
function HubState() constructor {
    entities = [];          // array of Entity IDs (string)
    sharedStorageId = "";   // e.g., stash id

    // Bundle E: array of PortalSlotState
    portalSlots = [];

    toStruct = function() {
        var slotsOut = [];
        if (is_array(portalSlots)) {
            for (var i = 0; i < array_length(portalSlots); i++) {
                var s = portalSlots[i];

                // Back-compat: older data stored "slotId" as a string
                if (is_string(s) || is_real(s)) {
                    s = new PortalSlotState(s);
                }

                // Serialize slot
                if (is_struct(s) && variable_struct_exists(s, "toStruct")) {
                    slotsOut[i] = s.toStruct();
                } else if (is_struct(s)) {
                    // Already a plain struct
                    slotsOut[i] = s;
                }
            }
        }

        return {
            entities: entities,
            sharedStorageId: sharedStorageId,
            portalSlots: slotsOut
        };
    };
}

function HubState_FromStruct(s) {
    var h = new HubState();

    if (!is_undefined(s) && is_struct(s)) {
        h.entities = (variable_struct_exists(s, "entities") && is_array(s.entities)) ? s.entities : [];
        h.sharedStorageId = variable_struct_exists(s, "sharedStorageId") ? s.sharedStorageId : "";

        // Bundle E: portalSlots can be [structs] or legacy [strings]
        h.portalSlots = [];
        if (variable_struct_exists(s, "portalSlots") && is_array(s.portalSlots)) {
            for (var i = 0; i < array_length(s.portalSlots); i++) {
                var raw = s.portalSlots[i];

                if (is_string(raw) || is_real(raw)) {
                    h.portalSlots[i] = new PortalSlotState(raw);
                } else if (is_struct(raw) && variable_struct_exists(raw, "slotId")) {
                    h.portalSlots[i] = PortalSlotState_FromStruct(raw);
                } else {
                    // Unknown entry -> still allocate something stable
                    h.portalSlots[i] = new PortalSlotState(i);
                }
            }
        }
    }

    return h;
}
