// Batalla final contra El Rey del Desequilibrio:
//  - Tres sellos = tres fases. Cada fase presenta una ecuación cuadrática
//    de su conjunto (2 por fase) y el jugador escribe LAS DOS raíces.
//  - Ambas raíces correctas al 1.er intento: el sello se rompe (100 puntos
//    + bono de tiempo). Al 2.º intento: se rompe (60 puntos).
//  - UNA sola raíz correcta: el escudo del jefe se agrieta, pero se
//    recarga; no hay daño ni puntos (el intento cuenta como fallido).
//  - Falla ambos intentos o se acaba el tiempo: el jugador pierde vida,
//    ve la factorización y la fase se repite con OTRA ecuación del conjunto.
//  - Sin vida: el jefe recupera sus tres sellos, se descartan los puntos
//    del combate y todo empieza de nuevo desde la fase 1.
//  - Tres sellos rotos: el ESCUDO CAE y el combate continúa. El jefe pasa a tener
//    3 puntos de energía y recibe daño como un enemigo normal (2 al acertar al
//    1.er intento, 1 al 2.º). Con 0 puntos de energía: victoria y fin del juego.
//  - Cada fallo cuesta 50 % de vida: dos golpes derrotan al jugador.

src_id    = "rey_desequilibrio";
src       = global.bank_src[$ src_id];
seals_max = 3;
broken    = 0;                 // sellos rotos
phase     = 1;                 // fase actual (1 a 3)
pool_i    = [0, 0, 0, 0];      // qué ecuación de cada fase toca (índices 1..3)
mark      = 0;                 // punto de control de results (para descartar si pierde)
last_ok   = false;
stage     = 1;                 // 1 = sellos y escudo | 2 = escudo caído, el jefe recibe daño
hp_max    = 3;                 // puntos de energía del jefe en la etapa 2
hp        = hp_max;
given     = {};                // ecuaciones ya mostradas en este combate
global.boss_shield = true;     // lo lee obj_exercise para el mensaje de respuesta parcial

state     = "intro";           // intro | fight | hit | shield_banner | shield_dialogue | win_banner | win_dialogue | lose_banner | lose_dialogue
t         = 0;
anim_in   = 0;
shake_e   = 0;
shake_p   = 0;
crack_t   = 0;                 // frames de las grietas del escudo
shatter_t = 0;                 // frames de la rotura del escudo
shield_a  = 1;                 // opacidad del escudo (0..1)
pop       = [];
banner    = "";
closing   = false;

ex_inst      = noone;          // el ejercicio en curso (para ver si hubo respuesta parcial)
partial_seen = 0;

// Posiciones en la escena
boss_x   = 900;   boss_y   = 292;
player_x = 300;   player_y = 292;

// Grietas del escudo: ángulo y largo de cada una
crack_ang = [20, 75, 130, 200, 255, 310];
crack_len = [60, 85, 55, 90, 70, 65];

// Tiempo por fase (docx: 70 a 90 s)
phase_time = function(_p) {
    return [70, 80, 90][_p - 1];
};

// Ids de las ecuaciones de una fase, en el orden del banco
phase_ids = function(_p) {
    var _ids = [];
    for (var i = 0; i < array_length(global.bank_list); i++) {
        var _e = global.bank_list[i];
        if (_e.level == 4 && variable_struct_exists(_e, "phase") && _e.phase == _p) array_push(_ids, _e.id);
    }
    return _ids;
};

// Inicio
start = function() {
    mark = results_mark();
    log_event("combate_inicio", src_id);
    sfx("snd_battle_start");
    state = "intro";
    dialogue_start(boss_intro_lines(), src.name, begin_fight);
};

begin_fight = function() {
    state = "fight";
    next_round();
};

// Una ronda = una ecuación
next_round = function() {
    var _ex, _time;
    if (stage == 1) {
        var _ids = phase_ids(phase);
        var _id  = _ids[pool_i[phase] mod array_length(_ids)];
        pool_i[phase]++;                                   // si falla, la próxima vez toca la otra ecuación
        _ex   = bank_get(_id);
        _time = phase_time(phase);
    } else {
        _ex   = pick_free();                               // etapa 2: una ecuación aún no vista
        _time = undefined;                                 // tiempo normal del nivel
    }
    given[$ _ex.id] = true;
    var _first = first_exercise_of_level(4);
    partial_seen = 0;
    ex_inst = exercise_launch(_ex, "battle", _first, on_round_done, _time);
};

// Etapa 2: siguiente ecuación del nivel 4 que aún no se mostró (si se agotan, reinicia el ciclo)
pick_free = function() {
    for (var pass = 0; pass < 2; pass++) {
        for (var i = 0; i < array_length(global.bank_list); i++) {
            var _e = global.bank_list[i];
            if (_e.level == 4 && !variable_struct_exists(given, _e.id)) return _e;
        }
        given = {};
    }
    return undefined;
};

on_round_done = function(_r) {
    record_result(_r);                     // suma los puntos (se descartan si pierde)
    state   = "hit";
    t       = 0;
    last_ok = _r.correct;

    if (stage == 1) {
        // Etapa 1: romper los sellos
        if (_r.correct) {
            broken++;
            shatter_t = 60;
            shake_e   = 24;
            array_push(pop, { x: boss_x, y: boss_y - 210, txt: "¡Sello roto!", col: COL_GOOD, t: 0 });
            log_event("sello_roto", string(broken));
            sfx("snd_seal_break");
        } else {
            var _pct = cfg_life_loss(4);
            life_lose(_pct);
            shake_p = 18;
            sfx("snd_hit_player");
            array_push(pop, { x: player_x, y: player_y - 190, txt: "-" + string(_pct) + " %", col: COL_BAD, t: 0 });
        }
    } else {
        // Etapa 2: el jefe recibe daño como un enemigo normal
        if (_r.correct) {
            var _dmg = (_r.attempt == 1) ? 2 : 1;
            hp = max(0, hp - _dmg);
            shake_e = 18;
            sfx("snd_hit_enemy");
            array_push(pop, { x: boss_x, y: boss_y - 210, txt: "-" + string(_dmg), col: COL_GOOD, t: 0 });
        } else {
            var _pct2 = cfg_life_loss(4);
            life_lose(_pct2);
            shake_p = 18;
            sfx("snd_hit_player");
            array_push(pop, { x: player_x, y: player_y - 190, txt: "-" + string(_pct2) + " %", col: COL_BAD, t: 0 });
        }
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
    global.boss_shield = false;
    closing = true;
    instance_destroy();
    quest_check_level(4);                  // completa el nivel 4: cierre, resultados y fin de sesión
};

// Derrota: el jefe recupera sus sellos y todo vuelve a empezar
set_lose = function() {
    state  = "lose_banner";
    banner = "Has caído...";
    jingle("mus_defeat");
    t = 0;
    results_rollback(mark);                // los puntos del combate no se conservan
    log_event("combate_derrota", src_id);
};

restart_fight = function() {
    life_reset();
    broken    = 0;
    phase     = 1;
    pool_i    = [0, 0, 0, 0];
    shield_a  = 1;
    stage     = 1;
    hp        = hp_max;
    given     = {};
    global.boss_shield = true;
    mark      = results_mark();
    banner    = "";
    log_event("combate_reinicio", src_id);
    state = "fight";
    next_round();
};


// Etapa 2: tras el tercer sello el escudo cae y el combate continúa
set_shield_down = function() {
    state  = "shield_banner";
    banner = "¡El escudo ha caído!";
    t = 0;
    log_event("escudo_caido", src_id);
    sfx("snd_shield_down");
};

begin_stage2 = function() {
    banner = "";
    stage  = 2;
    hp     = hp_max;
    global.boss_shield = false;
    state  = "fight";
    next_round();
};
