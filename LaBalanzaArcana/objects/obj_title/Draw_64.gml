var _cx = GUI_W / 2;

// Splash:
if (state == TITLE_STATE.SPLASH) {
    draw_set_colour(c_black);
    draw_rectangle(0, 0, GUI_W, GUI_H, false);

    // Entra y sale con un fundido
    var _a = clamp(min(t / 50, (260 - t) / 50), 0, 1);
    draw_set_alpha(_a);
    draw_set_font(fnt_ui);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(COL_DIM);
    draw_text(_cx, GUI_H / 2 - 56, "Proyecto del curso");
    draw_set_colour(COL_TEXT);
    draw_text(_cx, GUI_H / 2, "Sistemas Educativos Inteligentes");
    draw_set_colour(COL_DIM);
    draw_text(_cx, GUI_H / 2 + 56, "presenta");
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_colour(c_white);
    exit;
}

// Fondo común (todos los demás estados)
draw_sky(0);
draw_stars(stars, tt);
draw_glyphs(glyphs);

// Menú:
if (state == TITLE_STATE.MENU) {
    // Logotipo: la balanza se mece suavemente sobre el título
    draw_balance(_cx, 92, 5 * dsin(tt * 1.6), 0.70);

    draw_set_font(fnt_math);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_transformed(_cx + 3, 278, "LA BALANZA ARCANA", 1.25, 1.25, 0);       // sombra
    draw_set_colour(COL_WARN);
    draw_text_transformed(_cx, 275, "LA BALANZA ARCANA", 1.25, 1.25, 0);

    draw_set_font(fnt_ui);
    draw_set_colour(COL_DIM);
    draw_text(_cx, 384, "Aprende álgebra equilibrando el mundo");

    // Opciones
    var _my = 440;
    var _step = 42;
    for (var i = 0; i < array_length(menu_items); i++) {
        var _on = (i == sel);
        draw_set_colour(_on ? COL_WARN : COL_TEXT);
        draw_text(_cx, _my + i * _step, (_on ? ">  " : "    ") + menu_items[i] + (_on ? "  <" : "    "));
    }

    // Pie
    draw_set_halign(fa_left);
    draw_set_colour(COL_DIM);
    draw_text(24, GUI_H - 44, "v" + GAME_VERSION);
    draw_set_halign(fa_right);
    draw_text(GUI_W - 24, GUI_H - 44, "Flechas o W/S: mover     Enter: elegir");
    if (DEBUG_MODE) {
        draw_set_halign(fa_center);
        draw_set_colour(COL_BAD);
        draw_set_halign(fa_left);
        draw_text(24, 20, "[DEBUG] F2: entrar directo a la aldea");
    }
}

// Cómo jugar:
if (state == TITLE_STATE.HOWTO) {
    draw_panel(90, 50, GUI_W - 180, GUI_H - 100);
    draw_set_font(fnt_math);
    draw_set_halign(fa_center);
    draw_set_colour(COL_WARN);
    draw_text_transformed(_cx, 76, "Cómo jugar", 0.8, 0.8, 0);

    draw_set_font(fnt_ui);
    draw_set_halign(fa_left);
    draw_set_colour(COL_TEXT);
    var _hw = title_howto();
	var _hy = 155;
    var _scale = 0.85;
    var _sep = string_height("M") + 4;
    for (var i = 0; i < array_length(_hw); i++) {
        draw_text_ext_transformed(130, _hy, _hw[i], _sep, (GUI_W - 260) / _scale, _scale, _scale, 0);
        _hy += string_height_ext(_hw[i], _sep, (GUI_W - 260) / _scale) * _scale + 8;
    }
    draw_set_halign(fa_center);
    draw_set_colour(COL_DIM);
    draw_text(_cx, GUI_H - 95, "Enter: volver");
}

// Créditos:
if (state == TITLE_STATE.CREDITS) {
    draw_panel(240, 90, GUI_W - 480, GUI_H - 180);
    draw_set_font(fnt_math);
    draw_set_halign(fa_center);
    draw_set_colour(COL_WARN);
    draw_text(_cx, 116, "Créditos");

    draw_set_font(fnt_ui);
    var _lh = string_height("M") + 4;
    var _yy = 205;
    draw_set_colour(COL_TEXT);
    draw_text(_cx, _yy, "La Balanza Arcana"); _yy += _lh;
    draw_set_colour(COL_DIM);
    draw_text(_cx, _yy, "Proyecto del curso Sistemas Educativos Inteligentes"); _yy += _lh + 18;
    draw_set_colour(COL_WARN);
    draw_text(_cx, _yy, "Equipo"); _yy += _lh;
    draw_set_colour(COL_TEXT);
    var _cr = title_credits();
    for (var i = 0; i < array_length(_cr); i++) { draw_text(_cx, _yy, _cr[i]); _yy += _lh; }
    _yy += 10;
    draw_set_colour(COL_DIM);
    draw_text(_cx, _yy, "Arte y sonido: provisionales");
    draw_text(_cx, GUI_H - 145, "Enter: volver");
}

// Aviso de datos:
if (state == TITLE_STATE.NOTICE) {
    draw_panel(120, 70, GUI_W - 240, GUI_H - 140);
    draw_set_font(fnt_math);
    draw_set_halign(fa_center);
    draw_set_colour(COL_WARN);
    draw_text(_cx, 96, "Antes de empezar");

    draw_set_font(fnt_ui);
    draw_set_halign(fa_left);
    draw_set_colour(COL_TEXT);
    var _ny = 96 + string_height("M") * 2 + 24;
    draw_set_font(fnt_math);
    _ny = 96 + string_height("M") + 30;
    draw_set_font(fnt_ui);
    for (var i = 0; i < array_length(notice_wrapped); i++) {
        draw_text(160, _ny, notice_wrapped[i]);
        _ny += string_height(notice_wrapped[i]) + 22;
    }
    draw_set_halign(fa_center);
    draw_set_colour(COL_DIM);
    draw_text(_cx, GUI_H - 130, "Enter: entiendo, continuar     |     Esc: volver");
}

// Código de participante:
if (state == TITLE_STATE.CODE) {
    draw_panel(120, 70, GUI_W - 240, GUI_H - 140);
    draw_set_font(fnt_math);
    draw_set_halign(fa_center);
    draw_set_colour(COL_WARN);
    draw_text(_cx, 96, "Tu código de participante");
    var _th = string_height("M");

    draw_set_font(fnt_ui);
    var _lh = string_height("M") + 8;
    var _yy = 96 + _th + 24;
    draw_set_colour(COL_TEXT);
    draw_text_ext(_cx, _yy, "Escríbelo así: las 2 primeras letras de tu nombre, las 2 primeras de tu apellido y el día de tu nacimiento con 2 cifras.", _lh, GUI_W - 360);
    _yy += string_height_ext("Escríbelo así: las 2 primeras letras de tu nombre, las 2 primeras de tu apellido y el día de tu nacimiento con 2 cifras.", _lh, GUI_W - 360) + 10;
    draw_set_colour(COL_DIM);
    draw_text(_cx, _yy, "Ejemplo: María Torres, nacida un día 7  ->  MATO07"); _yy += _lh;
    var _code_note = "Sin tildes (la ñ se escribe N). Usa SIEMPRE el mismo código en el pre-test, el juego y el post-test.";
    draw_text_ext(_cx, _yy, _code_note, _lh, GUI_W - 360);
    _yy += string_height_ext(_code_note, _lh, GUI_W - 360) + 16;

    // Seis casillas, una por carácter
    draw_set_font(fnt_math);
    var _bw = 70, _bh = 84, _gap = 12;
    var _total = CODE_LEN * _bw + (CODE_LEN - 1) * _gap;
    var _bx0 = _cx - _total / 2;
    for (var i = 0; i < CODE_LEN; i++) {
        var _bx = _bx0 + i * (_bw + _gap);
        var _cur = (i == string_length(code_text));
        draw_set_colour(COL_INPUT_BG);
        draw_rectangle(_bx, _yy, _bx + _bw, _yy + _bh, false);
        draw_set_colour(_cur ? COL_WARN : COL_BORDER);
        draw_rectangle(_bx, _yy, _bx + _bw, _yy + _bh, true);
        draw_rectangle(_bx + 1, _yy + 1, _bx + _bw - 1, _yy + _bh - 1, true);
        draw_set_colour(COL_TEXT);
        draw_set_valign(fa_middle);
        draw_text(_bx + _bw / 2, _yy + _bh / 2, string_char_at(code_text, i + 1));
        draw_set_valign(fa_top);
    }
    _yy += _bh + 20;

    draw_set_font(fnt_ui);
    draw_set_colour(COL_BAD);
    draw_text(_cx, _yy, code_error);
    draw_set_colour(COL_DIM);
    draw_text(_cx, GUI_H - 130, "Enter: continuar     |     Esc: volver");
}

// Confirmar código:
if (state == TITLE_STATE.CONFIRM) {
    draw_panel(240, 110, GUI_W - 480, GUI_H - 220);
    draw_set_font(fnt_math);
    draw_set_halign(fa_center);
    draw_set_colour(COL_WARN);
    draw_text(_cx, 140, "¿Es correcto tu código?");
    var _th2 = string_height("M");

    draw_set_colour(COL_TEXT);
    draw_text_transformed(_cx, 140 + _th2 + 20, code_text, 1.4, 1.4, 0);

    draw_set_font(fnt_ui);
    var _lh2 = string_height("M") + 8;
    var _y3 = 140 + _th2 + 20 + _th2 * 1.4 + 22;
    draw_set_colour(COL_DIM);
    draw_text_ext(_cx, _y3, "Revísalo bien: con este código se unen tus resultados del pre-test, del juego y del post-test.", _lh2, GUI_W - 560);

    var _oy = GUI_H - 240;
    draw_set_colour((confirm_sel == 0) ? COL_WARN : COL_TEXT);
    draw_text(_cx - 160, _oy, ((confirm_sel == 0) ? ">  " : "    ") + "Sí, es correcto");
    draw_set_colour((confirm_sel == 1) ? COL_WARN : COL_TEXT);
    draw_text(_cx + 160, _oy, ((confirm_sel == 1) ? ">  " : "    ") + "Corregir");

    draw_set_colour(COL_DIM);
    draw_text_transformed(_cx, GUI_H - 160, "Izquierda / derecha: elegir     |     Enter: aceptar     |     Esc: volver", 0.64, 0.64, 0);
}

// Restaurar estado de dibujo
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_set_alpha(1);
