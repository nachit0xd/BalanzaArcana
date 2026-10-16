// Qué room corresponde a cada nivel, cómo se pasa de uno al siguiente y
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

// Inicia un nivel, la vida se restaura y se deja constancia
function level_begin(_level) {
    global.level = _level;
    life_reset();
    log_event("nivel_inicio", string(_level));
}

// Pasa a un nivel con un fundido a negro
function level_goto(_level) {
    level_begin(_level);
    room_transition(level_room(_level));
}

// Se llama al cerrar la pantalla de resultados de un nivel:
//  - Último nivel jugable: fin de la sesión
//  - Nivel 3: PUNTO DE NO RETORNO antes del jefe (el jugador elige)
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
// con el portón del castillo (obj_gate)
function threshold_choice() {
    choice_show("Ante ti se alza la sala de El Rey del Desequilibrio. Desde ahí no hay vuelta atrás.",
                [ "Entrar y enfrentarlo", "Seguir explorando el castillo" ],
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
