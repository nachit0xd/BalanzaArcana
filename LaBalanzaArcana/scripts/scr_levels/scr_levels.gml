// Script para qué room corresponde a cada nivel, cómo se pasa de uno al siguiente y
// el punto de no retorno antes de la batalla final

// Room de cada nivel
function level_room(_level) {
    switch (_level) {
        case 1: return rm_village;
        case 2: return rm_forest;
        case 3: return rm_castle;
        case 4: return rm_boss;
    }
    return rm_village;
}

// Punto de control al entrar por primera vez en un nivel
function level_checkpoint_save(_level) {
    var _badges = [];
    for (var i = 0; i < array_length(global.badges); i++) {
        array_push(_badges, global.badges[i]);
    }
    global.level_checkpoint = {
        level: _level,
        score: global.score,
        results_count: array_length(global.results),
        badges: _badges
    };
}

// La derrota invalida todo lo conseguido en el nivel actual, pero no los anteriores
function level_restart_from_defeat(_enemy_id) {
    var _cp = global.level_checkpoint;
    if (is_undefined(_cp) || _cp.level != global.level) {
        show_error("Falta el punto de control del nivel " + string(global.level), true);
        return;
    }

    while (array_length(global.results) > _cp.results_count) array_pop(global.results);
    global.score = _cp.score;
    global.badges = [];
    for (var b = 0; b < array_length(_cp.badges); b++) {
        array_push(global.badges, _cp.badges[b]);
    }

    var _sources = variable_struct_get_names(global.bank_src);
    for (var i = 0; i < array_length(_sources); i++) {
        var _s = global.bank_src[$ _sources[i]];
        if (_s.level != global.level) continue;
        variable_struct_remove(global.quests, _s.id);
        variable_struct_remove(global.decks, _s.id);
    }

    var _key = string(global.level);
    variable_struct_remove(global.life_lost, _key);
    variable_struct_remove(global.level_intro_seen, _key);
    variable_struct_remove(global.level_started, _key);
    variable_struct_remove(global.level_done, _key);
    life_reset();
    global.boss_shield = false;
    global.battle_grace_until = current_time + 1500;

    log_event("nivel_reinicio", "nivel=" + _key + "|enemigo=" + _enemy_id
        + "|puntaje_restaurado=" + string(global.score));
    room_transition(level_room(global.level));
}

// Inicia un nivel, la vida se restaura y se deja constancia
function level_begin(_level) {
    global.level = _level;
    life_reset();
	level_checkpoint_save(_level);
    log_event("nivel_inicio", string(_level));
}

// Pasa a un nivel con un fundido a negro
function level_goto(_level) {
    level_begin(_level);
    room_transition(level_room(_level));
}

// Se llama al cerrar la pantalla de resultados de un nivel:
//  - Último nivel jugable: fin de la sesión
//  - Nivel 3: punto de no retorno antes del jefe (el jugador elige)
//  - Resto: se pasa al siguiente nivel
function on_results_closed(_level) {
    if (_level >= LAST_PLAYABLE_LEVEL) {
        session_end_show();
    } else if (_level == 3) {
		sfx("snd_gate_unlock");
        // Pista: el menú de no retorno aparece solo al examinar el portón
        dialogue_start([ "Parece que la puerta se ha desbloqueado." ], "", undefined);
    } else {
        level_goto(_level + 1);
    }
}

// Punto de no retorno: antes de la batalla final el jugador
// decide si entra o si sigue explorando. Puede volver a decidir hablando
// con el portón del castillo (obj_barrier, barrier_kind = "gate")
function threshold_choice() {
    choice_show("Ante ti se alza la sala de El Rey del Desequilibrio. Desde ahí no hay vuelta atrás.",
                [ "Entrar y enfrentarlo", "Esperar un momento" ],
                threshold_chosen);
}

function threshold_chosen(_index) {
    if (_index == 0) level_goto(4);
}

// El jugador examina el portón, se abre solo cuando derrotó a todos los guardianes
function gate_interact() {
    if (level_requirements_met(3)) {
        threshold_choice();
    } else {
        dialogue_start([ "El portón del Rey está sellado por los guardianes de las ruinas.",
                         "Derrótalos a todos para abrirlo." ], "", undefined);
    }
}
