// Estado de una partida nueva. Se reinicia al iniciar el juego o una sesión.
function progress_reset() {
    global.level         = 1;
    global.score         = 0;
    global.life          = 100;
    global.badges        = [];
    global.quests        = {};    // id de NPC/enemigo -> { done }
    global.results       = [];    // un resultado por ejercicio (misiones y batallas)
    global.level_intro_seen = {}; // "1" -> true cuando el maestro ya dio la introducción de ese nivel
    global.level_started = {};    // "1" -> true tras lanzar el primer ejercicio del nivel
    global.level_done    = {};    // "1" -> true cuando el nivel se completó
    global.ui_cooldown   = 0;
	global.level_checkpoint = undefined;
	gamification_reset();      // vida, insignias y vida perdida por nivel
    decks_reset();
}

// Introducción del maestro al inicio de cada nivel:
// Se muestra una sola vez por nivel
function level_intro_start(_level) {
    var _key = string(_level);
    if (variable_struct_exists(global.level_intro_seen, _key)) return false;

    // Nivel sin texto de introducción: se da por visto
    if (!variable_struct_exists(global.level_intro, _key)) {
        global.level_intro_seen[$ _key] = true;
        return false;
    }

    // Se marca como vista al terminar el diálogo (si el jugador sale antes, se repite)
    var _on_done = method({ k: _key }, function() {
        global.level_intro_seen[$ k] = true;
    });
    return (dialogue_start(global.level_intro[$ _key], "Maestro", _on_done) != noone);
}

// true solo la primera vez que se llama para ese nivel. Sirve para saber si un ejercicio es el primero del nivel (y mostrar su pista por defecto).
function first_exercise_of_level(_level) {
    var _key = string(_level);
    if (variable_struct_exists(global.level_started, _key)) return false;
    global.level_started[$ _key] = true;
    return true;
}

// Misiones:
// Estado de la misión de un NPC o enemigo (se crea la primera vez)
function quest_get(_id) {
    if (!variable_struct_exists(global.quests, _id)) {
        global.quests[$ _id] = { done: false };
    }
    return global.quests[$ _id];
}

// Inicia la misión de un NPC (la llama obj_npc al pulsar la tecla de acción)
function mission_begin(_npc_id) {
    if (instance_exists(obj_mission)) return;
    if (exercise_active() || dialogue_active()) return;

    if (quest_get(_npc_id).done) {
        // Misión ya cumplida: solo una frase breve
        var _s = global.bank_src[$ _npc_id];
        dialogue_start(npc_repeat_lines(_npc_id), _s.name, undefined);
        return;
    }
    var _m = instance_create_depth(0, 0, 0, obj_mission);
    _m.start(_npc_id);
}

// Frases del NPC cuando su misión ya está hecha
function npc_repeat_lines(_npc_id) {
    var _t = global.src_text[$ _npc_id];
    if (!is_undefined(_t) && variable_struct_exists(_t, "repeat_lines")) return _t.repeat_lines;
    return [ "Ya me ayudaste con eso. ¡Gracias, aprendiz!" ];
}

// Fotograma de spr_npc para cada NPC (0 herrero, 1 molinera, 2 guardiana)
function npc_look_frame(_npc_id) {
    switch (_npc_id) {
        case "herrero":    return 0;
        case "molinera":   return 1;
        case "guardiana":  return 2;
        case "duende":     return 3;
        case "herbolaria": return 4;
        case "apicultor":  return 5;
        case "cartografa": return 6;
    }
    return 0;
}

// Registro de resultados: 
// Cada ejercicio terminado pasa por aquí
function record_result(_r) {
    array_push(global.results, _r);
    global.score += _r.points;
}

// Cierre de nivel:
// Un nivel está completo cuando todos sus NPC/enemigos tienen la misión hecha
function level_requirements_met(_level) {
    var _names = variable_struct_get_names(global.bank_src);
    for (var i = 0; i < array_length(_names); i++) {
        var _s = global.bank_src[$ _names[i]];
        if (_s.level == _level && !quest_get(_s.id).done) return false;
    }
    return true;
}

function quest_check_level(_level) {
    if (level_requirements_met(_level)) on_level_complete(_level);
}

function on_level_complete(_level) {
    var _key = string(_level);
    if (variable_struct_exists(global.level_done, _key)) return;
    global.level_done[$ _key] = true;

    show_debug_message("NIVEL " + _key + " COMPLETO | puntaje: " + string(global.score)
                       + " | ejercicios: " + string(array_length(global.results)));

    // Primero el cierre del maestro (si hay) y después la pantalla de resultados
    var _show_results = method({ lv: _level }, function() { results_show(lv, false); });
    if (variable_struct_exists(global.level_end_text, _key)) {
        dialogue_start(global.level_end_text[$ _key], "Maestro", _show_results);
    } else {
        _show_results();
    }
}
