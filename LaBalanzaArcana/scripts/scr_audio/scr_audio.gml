// Script de música y efectos de sonido

// El juego busca cada sonido por nombre. Si el asset todavía no existe, simplemente no suena

// Volumen: el general lo aplica audio_master_gain (scr_options); la música y los efectos usan opt_music_gain() y opt_sfx_gain()

#macro AUDIO_PRIO_MUSIC 100
#macro AUDIO_PRIO_SFX   10

// Nombres de los assets de sonido que el juego sabe usar
function audio_names() {
    return [
        // Música en bucle y "jingles" (suenan una sola vez)
        "mus_title", "mus_village", "mus_forest", "mus_castle", "mus_battle", "mus_boss",
        "mus_results", "mus_victory", "mus_defeat",
        // Menús
        "snd_ui_move", "snd_ui_select", "snd_ui_back",
        // Diálogos y respuestas
        "snd_blip", "snd_key", "snd_correct", "snd_wrong", "snd_hint", "snd_timeout", "snd_tick",
        // Combate
        "snd_battle_start", "snd_hit_enemy", "snd_hit_player",
        "snd_shield_crack", "snd_seal_break", "snd_shield_down",
        // Interfaz y mundo
        "snd_score", "snd_life_lost", "snd_badge", "snd_gate_unlock", "snd_whoosh"
    ];
}

// ID del asset con ese nombre, o -1 si aún no existe
function snd_find(_name) {
    var _a = asset_get_index(_name);
    return (_a != -1 && audio_exists(_a)) ? _a : -1;
}

function snd_id(_name) {
    if (variable_struct_exists(global.snd, _name)) return global.snd[$ _name];
    return -1;
}

// Se llama una vez desde el objeto obj_game (evento Create)
function audio_init() {
    global.snd = {};
    var _names   = audio_names();
    var _missing = "";
    var _found   = 0;
    for (var i = 0; i < array_length(_names); i++) {
        var _a = snd_find(_names[i]);
        global.snd[$ _names[i]] = _a;
        if (_a == -1) _missing += " " + _names[i]; else _found++;
    }
    global.music_snd    = -1;       // Pista que debería sonar (asset)
    global.music_inst   = -1;       // Instancia que está sonando
    global.music_gain   = 0;        // Ganancia actual de esa pista (para fundidos)
    global.music_fading = [];       // Pistas que se están apagando: { inst, g }
    global.music_step   = 0.02;     // Velocidad de los fundidos (1 s aprox.)
    global.jingle_until = 0;        // Mientras dura un jingle, la música de fondo baja

    if (DEBUG_MODE) {
        show_debug_message("AUDIO: " + string(_found) + " de " + string(array_length(_names)) + " sonidos encontrados.");
        if (_missing != "") show_debug_message("AUDIO: faltan:" + _missing);
    }
}

// Efectos de sonido:
function sfx(_name) {
    return sfx_ext(_name, 1, 1);
}

// _vol: factor 0..1 sobre el volumen de efectos | _pitch: 1 = tono normal
function sfx_ext(_name, _vol, _pitch) {
    var _s = snd_id(_name);
    if (_s == -1) return -1;
    var _i = audio_play_sound(_s, AUDIO_PRIO_SFX, false);
    audio_sound_gain(_i, _vol * opt_sfx_gain(), 0);
    audio_sound_pitch(_i, _pitch);
    return _i;
}

// Tono del "blip" de los diálogos según quién habla: maestro grave, NPC agudo, enemigo muy grave
function voice_pitch(_pid) {
    if (_pid == "maestro") return 0.85;
    if (_pid != "" && variable_struct_exists(global.bank_src, _pid)) {
        return (global.bank_src[$ _pid].kind == "npc") ? 1.1 : 0.7;
    }
    return 1;
}

// Música:
// Qué pista corresponde ahora, según dónde está el jugador ("" = silencio)
function music_desired() {
    if (boss_active())   return "mus_boss";
    if (battle_active()) return "mus_battle";
    switch (room) {
        case rm_title:
        case rm_intro:   return "mus_title";
        case rm_village: return "mus_village";
        case rm_forest:  return "mus_forest";
        case rm_castle:  return "mus_castle";
        case rm_boss:    return "mus_castle";      // Antes de empezar el combate final
    }
    return "";
}

// Cambia de pista: la anterior se apaga con un fundido y la nueva entra con otro
function music_switch(_s) {
    if (global.music_inst != -1) array_push(global.music_fading, { inst: global.music_inst, g: global.music_gain });
    global.music_snd  = _s;
    global.music_inst = -1;
    global.music_gain = 0;
    if (_s != -1) {
        global.music_inst = audio_play_sound(_s, AUDIO_PRIO_MUSIC, true);
        audio_sound_gain(global.music_inst, 0, 0);          // entra desde el silencio
    }
}

// Jingle: un sonido corto de música (victoria, derrota...). La música de fondo baja mientras suena
function jingle(_name) {
    var _s = snd_id(_name);
    if (_s == -1) return;
    var _i = audio_play_sound(_s, AUDIO_PRIO_MUSIC + 1, false);
    audio_sound_gain(_i, opt_music_gain(), 0);
    global.jingle_until = current_time + audio_sound_length(_s) * 1000;
}

// Se llama en cada evento Step de obj_game
function audio_update() {
    // Check de ¿cambió la pista que corresponde?
    var _want = music_desired();
    var _s    = (_want == "") ? -1 : snd_id(_want);
    if (_s != global.music_snd) music_switch(_s);

    // Ganancia objetivo, baja durante un jingle y en la pausa
    var _target = 1;
    if (current_time < global.jingle_until) _target = 0.12;
    else if (pause_active())                _target = 0.4;

    if (global.music_inst != -1) {
        global.music_gain += clamp(_target - global.music_gain, -global.music_step * 2, global.music_step);
        audio_sound_gain(global.music_inst, global.music_gain * opt_music_gain(), 0);
    }

    // Las pistas anteriores se apagan poco a poco
    for (var i = array_length(global.music_fading) - 1; i >= 0; i--) {
        var _f = global.music_fading[i];
        _f.g -= global.music_step;
        if (_f.g <= 0) {
            audio_stop_sound(_f.inst);
            array_delete(global.music_fading, i, 1);
        } else {
            audio_sound_gain(_f.inst, _f.g * opt_music_gain(), 0);
        }
    }
}

// Sonidos de menús (los llama obj_game, no hay que tocar cada menú):
function menu_context_active() {
    if (instance_exists(obj_title)) {
        // En el título, no durante la presentación ni al escribir el código
        return (obj_title.state != TITLE_STATE.CODE && obj_title.state != TITLE_STATE.SPLASH);
    }
    return pause_active() || options_active() || choice_active() || results_active() || session_end_active();
}
