if (is_undefined(ex) || closing) exit;

var _battle = (ctx == "battle");
var _in_ask = (state == EX_STATE.ASK1 || state == EX_STATE.ASK2);
var _src    = global.bank_src[$ ex.src];
var _acc    = role_color(ex.src);                      // Dorado = NPC, rojo = enemigo
var _lh     = lay.lh;
var _cx     = GUI_W / 2;
var _remind = (show_reminder || manual_hint || global.opt.hints_always);
var _t      = msg_texts();
var _ttl_hint = _battle ? "" : "Pista";              

// Fondo atenuado (solo en misiones) y panel
if (!_battle) {
    draw_set_alpha(0.7);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, GUI_W, GUI_H, false);
    draw_set_alpha(1);
}
draw_panel(lay.px, lay.py, lay.pw, lay.ph);
draw_set_colour(_acc);                                  // El borde toma el color de quien habla (NPC, Maestro o Enemigo)
draw_rectangle(lay.px, lay.py, lay.px + lay.pw, lay.py + lay.ph, true);
draw_rectangle(lay.px + 2, lay.py + 2, lay.px + lay.pw - 2, lay.py + lay.ph - 2, true);

// Encabezado: quién es, y el intento como dos puntos
draw_set_font(fnt_ui);
draw_set_valign(fa_top);
var _dots_y;
if (!_battle) {
    portrait_mini(ex.src, lay.px + 24, lay.py + 8, 80, _acc);
    draw_set_halign(fa_left);
    draw_set_colour(_acc);
    draw_text(lay.px + 120, lay.py + 18, _src.name);
    draw_set_colour(COL_DIM);
    draw_text(lay.px + 120, lay.py + 18 + _lh, "Misión de NPC");
    _dots_y = lay.py + 18 + _lh / 2;
} else {
    draw_set_halign(fa_left);
    draw_set_colour(_acc);
    draw_text(lay.px + 32, lay.py + 14, _src.name);
    _dots_y = lay.py + 14 + _lh / 2;
}
draw_dots(lay.px + lay.pw - 48, _dots_y, 2, attempt, _acc);
draw_set_halign(fa_right);
draw_set_colour(COL_DIM);
draw_text(lay.px + lay.pw - 48 - 34 - 22, _dots_y - _lh / 2 + 3, "Intento");

// Cronómetro por segmentos (solo batalla)
if (time_limit > 0 && _in_ask) {
    var _left_s = max(0, time_limit - t_elapsed);
    draw_timer_bar(lay.px + 32, lay.timer_y, lay.pw - 64, 14, clamp(_left_s / time_limit, 0, 1), _left_s);
    draw_set_halign(fa_center);
    draw_set_colour((_left_s <= 5) ? COL_BAD : COL_TEXT);
    draw_text(_cx, lay.py + 14, string(ceil(_left_s)) + " s");
}

// Enunciado y tarjeta con la ecuación
var _card_y;
draw_set_halign(fa_left);
draw_set_colour(COL_TEXT);
if (!_battle) {
    draw_text_ext(lay.story_x, lay.story_y, story, _lh, lay.story_w);
    _card_y = lay.card_y;
} else if (state == EX_STATE.ASK1) {
    draw_text_scaled(lay.lx, lay.story_y_battle, story, _lh * lay.story_scale, lay.lw, lay.story_scale);
    _card_y = lay.card_y_ask;
} else {
    _card_y = lay.card_y_ans;                           // Tras responder, el enunciado cede su lugar
}
if (lay.show_eq) {
    draw_card(lay.card_x, _card_y, lay.card_w, lay.card_h, COL_BORDER);
    draw_set_font(fnt_math);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(COL_TEXT);
    if (_battle) draw_text_transformed(lay.card_x + lay.card_w / 2, _card_y + lay.card_h / 2, ex_equation_string(ex), 0.72, 0.72, 0);
    else         draw_text(lay.card_x + lay.card_w / 2, _card_y + lay.card_h / 2, ex_equation_string(ex));
    draw_set_font(fnt_ui);
    draw_set_valign(fa_top);
}

// Mensajes (banners)
draw_set_halign(fa_left);
if (!_battle) {
    var _bx = lay.fb_x, _by = lay.fb_y, _bw = lay.fb_w;
    switch (state) {
        case EX_STATE.ASK1:
            if (_remind) {
                draw_banner(_bx, _by, _bw, "hint", "Pista", ex_reminder(ex), "");
            } else {
                draw_set_colour(COL_DIM);
                draw_text(_bx, _by + 8, "Pulsa H si necesitas una pista.");
            }
            break;
        case EX_STATE.WRONG1:
            draw_banner(_bx, _by, _bw, "err", _t.wrong, hint, "");
            break;
        case EX_STATE.ASK2:
            draw_banner(_bx, _by, _bw, "hint", "Pista", hint, "");
            break;
        case EX_STATE.OK:
            draw_banner(_bx, _by, _bw, "ok", msg_ok, _t.ok_body, "");
            break;
        case EX_STATE.KCR:
            draw_banner(_bx, _by, _bw, "err", _t.kt, steps_text, _t.answer);
            break;
    }
} else {
    // Derecha: bajo la caja de respuesta. Izquierda: bajo la tarjeta (pista o procedimiento)
    var _rx = lay.rx, _ry = lay.fb_y, _rw = lay.rw;
    var _lx = lay.lx, _ly = lay.card_y_ans + lay.card_h + 10, _lw = lay.lw;
    switch (state) {
        case EX_STATE.ASK1:
            if (_remind) {
                draw_banner(_rx, _ry, _rw, "hint", "", ex_reminder(ex), "");
            } else {
                draw_set_colour(COL_DIM);
                draw_text(_rx, _ry + 8, "Pulsa H si necesitas una pista.");
            }
            break;
        case EX_STATE.WRONG1:
            draw_banner(_rx, _ry, _rw, "err", _t.wrong, _t.partial, "");
            draw_banner(_lx, _ly, _lw, "hint", "", hint, "");
            break;
        case EX_STATE.ASK2:
            draw_banner(_lx, _ly, _lw, "hint", "", hint, "");
            break;
        case EX_STATE.OK:
            draw_banner(_rx, _ry, _rw, "ok", msg_ok, _t.ok_body, "");
            break;
        case EX_STATE.KCR:
            draw_banner(_rx, _ry, _rw, "err", _t.kt, "", _t.answer);
            draw_banner(_lx, _ly, _lw, "info", "", steps_text, "");
            break;
    }
}

// Pie: teclas disponibles
var _pairs;
if (_in_ask) {
    _pairs = [ ["Enter", "Enviar"] ];
    if (ex.level == 4) array_push(_pairs, ["Tab", "Cambiar de campo"]);
    if (state == EX_STATE.ASK1) array_push(_pairs, ["H", "Pista"]);
} else if (state == EX_STATE.WRONG1) {
    _pairs = [ ["Enter", "Reintentar"] ];
} else {
    _pairs = [ ["Enter", "Continuar"] ];
}
draw_keycaps_row(_cx, lay.foot_y, _pairs);

// Restaurar estado de dibujo
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_set_alpha(1);
