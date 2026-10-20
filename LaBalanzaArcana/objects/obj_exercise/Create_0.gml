// Objeto que actúa como controlador del flujo de un ejercicio. 
// Se usa en las misiones de NPC y las batallas.

ex            = undefined;      // Ejercicio del banco
ctx           = "npc";          // "npc" | "battle"
state         = EX_STATE.ASK1;
state_t       = 0;              // Frames transcurridos en el estado actual
attempt       = 1;              // Intento actual (1 o 2)
time_limit    = 0;              // Segundos por intento (0 = sin cronómetro)
t_elapsed     = 0;              // Segundos usados en el intento actual
show_reminder = false;          // Pista por defecto (primer ejercicio del nivel)
timed_out     = false;
wrong_hits    = 0;              // Nivel 4: raíces acertadas en el intento fallido
last_points   = 0;
last_bonus    = 0;
msg_ok        = "";
story         = "";
hint          = "";
steps_text    = "";
pending_result = undefined;
result        = undefined;
on_done       = undefined;
box           = noone;
closing       = false;          // true mientras se está cerrando
lay           = {};             // Medidas de la pantalla (las calcula compute_layout)
manual_hint   = false;          // El jugador pidió la pista con la tecla H
last_tick     = -1;             // Último segundo en que sonó el tic de la cuenta atrás
partial_hit   = 0;              // Nivel 4: veces que respondió con UNA sola raíz correcta (lo lee el jefe)

// Inicio: lo llama la función exercise_launch()
start = function(_ex, _ctx, _first_of_level, _on_done, _time) {
    ex            = _ex;
    ctx           = _ctx;
    on_done       = _on_done;
    show_reminder = _first_of_level;
    time_limit    = (_ctx == "battle") ? cfg_time(_ex.level) : 0;
    if (!is_undefined(_time)) time_limit = _time;      // Tiempo propio (ej: las fases del jefe)

    // Todo el texto se deriva del banco de preguntas
    story = ex_story(_ex);
    hint  = ex_hint(_ex);
    var _steps = ex_steps(_ex);
    steps_text = "";
    // Si la ecuación está a la vista (tarjeta), el procedimiento no la repite
    var _skip_eq = (_ctx == "battle") || (_ex.level == 4) || global.cfg.show_eq_npc;
    for (var i = _skip_eq ? 1 : 0; i < array_length(_steps); i++) {
        steps_text += ((steps_text != "") ? "\n" : "") + _steps[i];
    }

    // Caja de respuesta: su posición la define la función compute_layout
    var _fields = (_ex.level == 4) ? 2 : 1;
    box = instance_create_depth(0, 0, -1001, obj_answer_box);
    compute_layout(_fields);

    set_state(EX_STATE.ASK1);
};

// Textos de los mensajes (los usan compute_layout y el dibujo)
msg_texts = function() {
    var _battle = (ctx == "battle");
    var _t = {};
    _t.wrong   = _battle ? "Todavía no está equilibrada." : global.msgs.wrong1;
    _t.partial = "";
    if (ex.level == 4 && wrong_hits == 1) {
        var _shield = (variable_global_exists("boss_shield") && global.boss_shield);
        _t.partial = _shield ? "¡Una raíz es correcta! El escudo se agrieta, pero se recarga."
                             : "¡Una de tus raíces es correcta! Te falta la otra.";
    }
    _t.kt      = _battle ? (timed_out ? global.msgs.timeout : "Sin acierto esta vez.")
                         : ((timed_out ? global.msgs.timeout + " " : "") + global.msgs.kcr);
    _t.answer  = "Respuesta: " + ex_solution_string(ex);
    _t.ok_body = "+" + string(last_points) + " puntos" + ((last_bonus > 0) ? "   (incluye +" + string(last_bonus) + " por rapidez)" : "");
    return _t;
};

// Medidas de la pantalla (se calculan una sola vez, al empezar el ejercicio)
compute_layout = function(_fields) {
    draw_set_font(fnt_ui);
    var _lh = string_height("M") + 6;
    draw_set_font(fnt_math);
    var _mh = string_height("M");
    draw_set_font(fnt_ui);

    lay.lh      = _lh;
    lay.show_eq = (ctx == "battle") || (ex.level == 4) || global.cfg.show_eq_npc;
    lay.card_h  = lay.show_eq ? ((ctx == "battle") ? round(_mh * 0.72) + 24 : _mh + 28) : 0;

    if (ctx == "battle") {
        // Panel inferior de dos columnas: izquierda = enunciado y ecuación; derecha = caja de respuesta y mensajes
        lay.px = 32;  lay.py = 300;  lay.pw = GUI_W - 64;  lay.ph = GUI_H - 324;
        lay.lx = lay.px + 32;   lay.lw = 560;
        lay.rx = lay.px + 624;  lay.rw = 560;
        lay.timer_y = lay.py + 54;
        lay.body_y  = lay.py + 84;
        lay.card_x  = lay.lx;
        lay.card_w  = lay.lw;
        lay.card_y_ask = lay.body_y;  // Ecuación arriba: los textos largos quedan debajo
        lay.card_y_ans = lay.body_y;                                                // Al responder, el enunciado se oculta
        lay.fb_y    = lay.body_y + 64 + 14;                                         // Mensajes bajo la caja de respuesta
        lay.foot_y  = lay.py + lay.ph - 28;
        box.configure(_fields, lay.rx + lay.rw / 2, lay.body_y, (_fields == 2));
		lay.story_y_battle = lay.card_y_ask + lay.card_h + 14;
        lay.story_scale = 1.0;
        var _story_room = lay.foot_y - 28 - lay.story_y_battle;
        repeat (10) {
            if (string_height_ext(story, _lh, lay.lw / lay.story_scale) * lay.story_scale <= _story_room) break;
            lay.story_scale = max(0.55, lay.story_scale - 0.05);
        }
    } else {
        // Panel centrado, con encabezado con retrato, enunciado, tarjeta, respuesta y mensajes
        var _pw = 1000, _cw = _pw - 64;
        var _hdr = 96;
        var _sh  = string_height_ext(story, _lh, _cw);

        var _t = msg_texts();
        var _h_wrong = banner_height(_cw, _t.wrong, hint, "");
        var _h_hint  = banner_height(_cw, "Pista", hint, "");
        var _h_kcr   = banner_height(_cw, _t.kt, steps_text, _t.answer);
        var _h_ok    = banner_height(_cw, "¡Correcto! ¡Sigue así!", "+000 puntos   (incluye +00 por rapidez)", "");
        var _fb = max(_h_wrong, _h_hint, _h_kcr, _h_ok, 72) + 4;

        var _gap_card = (lay.card_h > 0) ? 20 : 0;
        var _total = _hdr + 8 + _sh + 20 + lay.card_h + _gap_card + 64 + 20 + _fb + 56;

        lay.pw = _pw;  lay.ph = _total;
        lay.px = (GUI_W - _pw) / 2;
        lay.py = max(12, (GUI_H - _total) / 2);
        lay.story_x = lay.px + 32;  lay.story_y = lay.py + _hdr + 8;  lay.story_w = _cw;
        lay.card_x  = GUI_W / 2 - 280;  lay.card_w = 560;
        lay.card_y  = lay.story_y + _sh + 20;
        lay.input_y = lay.card_y + lay.card_h + _gap_card;
        lay.fb_x = lay.px + 32;  lay.fb_y = lay.input_y + 64 + 20;  lay.fb_w = _cw;
        lay.foot_y = lay.py + lay.ph - 32;
        box.configure(_fields, GUI_W / 2, lay.input_y, false);
    }
};

// Cambio de estado
set_state = function(_s) {
    state   = _s;
    state_t = 0;
    keyboard_string = "";
    switch (_s) {
        case EX_STATE.ASK1: attempt = 1; begin_attempt(); break;
        case EX_STATE.ASK2: attempt = 2; begin_attempt(); break;
        default:            box.disable(); break;       // WRONG1, KCR, OK
    }
};

begin_attempt = function() {
    t_elapsed = 0;          // Cada intento tiene su propio cronómetro completo
    last_tick = -1;
    box.enable();
};

continue_pressed = function() {
    return keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
};

make_result = function(_correct, _attempt, _pts, _timeout, _left) {
    return {
        id            : ex.id,
        src           : ex.src,
        level         : ex.level,
        ctx           : ctx,
        correct       : _correct,     // Hace check de ¿resolvió el ejercicio?
        attempt       : _attempt,     // Intento en que acertó (1 o 2); 0 si no acertó
        points        : _pts,
        timed_out     : _timeout,     // true si se acabó el tiempo
        time_left_pct : _left,        // Fracción de tiempo restante al acertar
        roots_hit     : wrong_hits    // Solo para el nivel 4
    };
};

// El jugador envió una respuesta
resolve_answer = function() {
    var _vals     = box.get_values();
    var _ok       = ex_check(ex, _vals);
    var _left_pct = (time_limit > 0) ? clamp(1 - t_elapsed / time_limit, 0, 1) : 1;

    log_attempt({ ex:ex, ctx:ctx, attempt:attempt, answer:box.get_text(),
                  correct:_ok, ms:round(t_elapsed * 1000), timeout:false });

    sfx(_ok ? "snd_correct" : "snd_wrong");

    // Nivel 4: hace check de ¿acertó exactamente una de las dos raíces? (agrieta el escudo del jefe)
    var _hits = (ex.level == 4) ? ex_roots_hit(ex, _vals) : 0;
    if (!_ok && _hits == 1) partial_hit++;

    if (_ok) {
        last_points = score_calc(attempt, ctx, _left_pct);
        last_bonus  = last_points - score_base(attempt);
        msg_ok      = global.msgs.ok[irandom(array_length(global.msgs.ok) - 1)];
        pending_result = make_result(true, attempt, last_points, false, _left_pct);
        set_state(EX_STATE.OK);
    } else if (attempt == 1) {
        wrong_hits = _hits;
        set_state(EX_STATE.WRONG1);               // Pista, sin dar la respuesta
    } else {
        wrong_hits = _hits;
        pending_result = make_result(false, 0, 0, false, 0);
        set_state(EX_STATE.KCR);                  // Respuesta + Procedimiento
    }
};

// Se acabó el tiempo (solo en batalla)
resolve_timeout = function() {
    log_attempt({ ex:ex, ctx:ctx, attempt:attempt, answer:box.get_text(),
                  correct:false, ms:round(t_elapsed * 1000), timeout:true });
    sfx("snd_timeout");
    timed_out = true;
    pending_result = make_result(false, 0, 0, true, 0);
    set_state(EX_STATE.KCR);                      // Sin segundo intento
};

// Fin del ejercicio
finish = function() {
    closing = true;
    result = pending_result;
    var _cb = on_done;
    var _r  = result;
    if (instance_exists(box)) instance_destroy(box);
    instance_destroy();
    if (!is_undefined(_cb)) _cb(_r);
};
