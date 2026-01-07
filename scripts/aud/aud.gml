/// Bundle J (minimal early) - Audio routing with safe no-ops.
/// Uses asset_get_index() so missing sounds don't crash.

function SJ_Audio_Play(_soundName) {
	var snd = asset_get_index(string(_soundName));
	if (snd >= 0) audio_play_sound(snd, 0, false);
}

function SJ_Audio_UIConfirm() { SJ_Audio_Play("snd_ui_confirm"); }
function SJ_Audio_UIReject()  { SJ_Audio_Play("snd_ui_reject"); }
function SJ_Audio_UIHover()   { SJ_Audio_Play("snd_ui_hover"); }
