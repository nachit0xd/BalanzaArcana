// Este objeto controla un combate contra un enemigo. Primero va la introducción, luego las rondas y finalmente la conclusión del combate.
// En cada ronda existen tres escenarios: correcta al 1.er intennto (enemigo pierde 2 puntos de energía), correcta al 2.º intento (enemigo pierde 1 punto de vida),
// y fallo en ambos o tiempo acabado (el jugador pierde cierto porcentaje de vida).
// Al acabarse su vida, el jugador pierde y vuelve al inicio del nivel.

src_id     = "";
src        = undefined;     // Datos del enemigo en el banco
enemy_inst = noone;         // El enemigo del mundo abierto
hp_max     = 0;             // Puntos de energía iniciales
hp         = 0;
deck       = undefined;     // Sus ejercicios; nunca toma preguntas de otro enemigo
look       = 0;             // Fotograma del enemigo
state      = "intro";       // intro | fight | hit | win_banner | win_dialogue | lose_banner | lose_dialogue
t          = 0;
anim_in    = 0;             // Aparición de la escena (0..1)
shake_e    = 0;             // Temblor del enemigo al recibir daño
shake_p    = 0;             // Temblor del jugador al recibir daño
pop        = [];            // Textos flotantes { x, y, txt, col, t }
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
    deck       = deck_get(_src_id);
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

// Una ronda equivale a un ejercicio del banco de preguntas del enemigo
next_round = function() {
    var _ex    = deck_next(deck);
    var _first = first_exercise_of_level(src.level);      // El primer ejercicio del nivel siempre muestra la pista, esté activada la opción o no
    exercise_launch(_ex, "battle", _first, on_round_done);
};

on_round_done = function(_r) {
    record_result(_r);                     // Se suma puntos; se revierten si se reinicia el nivel
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
    global.battle_grace_until = current_time + 1500;                // Margen de tiempo antes de otro combate

    var _lvl = src.level;
    closing = true;
    instance_destroy();
    quest_check_level(_lvl);                             // Check para ver si se completó el nivel
};

// Derrota: al terminar el diálogo, se reinicia todo el nivel
set_lose = function() {
    state  = "lose_banner";
    banner = "Has caído...";
    jingle("mus_defeat");
    t = 0;
    log_event("combate_derrota", src_id);
};

restart_level = function() {
    var _defeated_by = src_id;
    closing = true;
    level_restart_from_defeat(_defeated_by);
    instance_destroy();
};
