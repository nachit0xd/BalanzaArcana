// Controla un combate contra un enemigo:
//   intro del enemigo -> rondas (un ejercicio por ronda) -> victoria
//   Resultado de cada ronda:
//     correcta al 1.er intento : el enemigo pierde 2 puntos de energía
//     correcta al 2.º intento  : el enemigo pierde 1 punto
//     fallo en ambos / tiempo  : el jugador pierde vida (según el nivel)
//   Sin vida -> derrota: se descartan los puntos del combate, la vida
//   se restaura y el combate se reinicia desde el principio.

src_id     = "";
src        = undefined;     // datos del enemigo en el banco
enemy_inst = noone;         // el enemigo del mundo abierto
hp_max     = 0;             // puntos de energía iniciales
hp         = 0;
deck       = undefined;     // sus ejercicios (se conserva entre reintentos)
mark       = 0;             // punto de control de results (para descartar si pierde)
look       = 0;             // fotograma del enemigo
state      = "intro";       // intro | fight | hit | win_banner | win_dialogue | lose_banner | lose_dialogue
t          = 0;
anim_in    = 0;             // aparición de la escena (0..1)
shake_e    = 0;             // temblor del enemigo al recibir daño
shake_p    = 0;             // temblor del jugador al recibir daño
pop        = [];            // textos flotantes { x, y, txt, col, t }
banner     = "";
closing    = false;

// Posiciones en la escena (coordenadas de GUI)
enemy_x  = 940;   enemy_y  = 280;
player_x = 340;   player_y = 280;

// Inicio
start = function(_src_id, _enemy_inst) {
    src_id     = _src_id;
    src        = global.bank_src[$ _src_id];
    enemy_inst = _enemy_inst;
    hp_max     = src.hp;
    hp         = hp_max;
    deck       = deck_get(_src_id);        // si pierde y reintenta, recibe ejercicios aún no vistos
    mark       = results_mark();
    look       = enemy_look_frame(_src_id);

    log_event("combate_inicio", src_id);
    sfx("snd_battle_start");
    state = "intro";
    dialogue_start(battle_intro_lines(src_id), src.name, begin_fight);
};

begin_fight = function() {
    state = "fight";
    next_round();
};

// Una ronda equivale a un ejercicio
next_round = function() {
    var _ex    = deck_next(deck);
    var _first = first_exercise_of_level(src.level);      // el primer ejercicio del nivel muestra la pista
    exercise_launch(_ex, "battle", _first, on_round_done);
};

on_round_done = function(_r) {
    record_result(_r);                     // suma los puntos (se descartan si pierde)
    state = "hit";
    t = 0;

    if (_r.correct) {
        var _dmg = (_r.attempt == 1) ? 2 : 1;
        hp = max(0, hp - _dmg);
        shake_e = 18;
        sfx("snd_hit_enemy");
        array_push(pop, { x: enemy_x, y: enemy_y - 70, txt: "-" + string(_dmg), col: COL_GOOD, t: 0 });
    } else {
        var _pct = cfg_life_loss(src.level);
        life_lose(_pct);
        shake_p = 18;
        sfx("snd_hit_player");
        array_push(pop, { x: player_x, y: player_y - 70, txt: "-" + string(_pct) + " %", col: COL_BAD, t: 0 });
    }
};

// Victoria
set_win = function() {
    state  = "win_banner";
    banner = "¡Victoria!";
    jingle("mus_victory");
    t = 0;
};

finish_win = function() {
    quest_get(src_id).done = true;
    log_event("combate_victoria", src_id);
    if (instance_exists(enemy_inst)) instance_destroy(enemy_inst);
    global.battle_grace_until = current_time + 1500;     // margen antes de otro combate

    var _lvl = src.level;
    closing = true;
    instance_destroy();
    quest_check_level(_lvl);                             // ¿se completó el nivel?
};

//  Derrota, se reinicia el combate desde el principio
set_lose = function() {
    state  = "lose_banner";
    banner = "Has caído...";
    jingle("mus_defeat");
    t = 0;
    results_rollback(mark);                              // los puntos del combate no se conservan
    log_event("combate_derrota", src_id);
};

restart_fight = function() {
    life_reset();                                        // vida completa para el nuevo intento
    hp     = hp_max;
    mark   = results_mark();
    banner = "";
    log_event("combate_reinicio", src_id);
    state = "fight";
    next_round();
};
