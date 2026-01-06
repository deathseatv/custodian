/// Bundle D - Hub & Character Lifecycle
/// Minimal UI surface (stub).

function HubUI() constructor {
    // Test-visible "last *" fields (used by Bundle D unit tests)
    lastInhabitPromptId = undefined;
    lastRetirePromptId = undefined;
    lastErrorMessage = undefined;

    showInhabitPrompt = function(_characterId) {
        lastInhabitPromptId = string(_characterId);
    };

    showRetirePrompt = function(_characterId) {
        lastRetirePromptId = string(_characterId);
    };

    showError = function(_message) {
        lastErrorMessage = string(_message);
    };
}
