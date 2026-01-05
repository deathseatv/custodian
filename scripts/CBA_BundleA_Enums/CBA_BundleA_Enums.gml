/// Bundle A Persistence Backbone - GML 2.3+ (struct-based "classes")
/// Generated: 20260104222854 UTC
/// Notes:
/// - Pragmatic stubs meant to be expanded in your project.
/// - Uses JSON-based serialization to keep dependencies minimal.
/// - Assumes GMS 2.3+ (constructors via `function Name(...) constructor {}`).

/// @desc Enums used across Bundle A
enum PortalState { Empty, Open, Dormant }

enum CorruptAction { Reject, AttemptRepair, LoadLastGood, CreateNew }
enum MissingRefAction { DropReference, SpawnPlaceholder, FailLoad }
enum UnknownTypeAction { DropObject, StubObject, FailLoad }
