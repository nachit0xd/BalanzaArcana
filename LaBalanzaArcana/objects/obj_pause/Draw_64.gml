if (closing) exit;

var _cx = GUI_W / 2;
draw_set_alpha(0.65);
draw_set_colour(c_black);
draw_rectangle(0, 0, GUI_W, GUI_H, false);
draw_set_alpha(1);

draw_set_font(fnt_math);
var _th = string_height("M");
draw_set_font(fnt_ui);
var _lh = string_height("M") + 14;

if (mode == "main") {
    var _pw = 560, _ph = 170 + _th + array_length(items) * _lh;
    var _px = _cx - _pw / 2, _py = (GUI_H - _ph) / 2;
    draw_panel(_px, _py, _pw, _ph);

    draw_set_font(fnt_math);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_colour(COL_WARN);
    draw_text(_cx, _py + 28, "Pausa");

    // Estado exacto de la partida (la barra de vida del HUD solo muestra golpes)
    draw_set_font(fnt_ui);
    draw_set_colour(COL_DIM);
    draw_text(_cx, _py + 28 + _th + 14, "Vida " + string(round(global.life)) + " %   -   Puntaje " + string(global.score));

    draw_set_font(fnt_ui);
    for (var i = 0; i < array_length(items); i++) {
        var _on = (i == sel);
        draw_set_colour(_on ? COL_WARN : COL_TEXT);
        draw_text(_cx, _py + 28 + _th + 72 + i * _lh, (_on ? ">  " : "    ") + items[i] + (_on ? "  <" : "    "));
    }
    draw_set_colour(COL_DIM);
    draw_text(_cx, _py + _ph - 44, "Esc: continuar");
} else {
    // Cómo jugar
    var _pw2 = 1100, _ph2 = 620;
    var _px2 = _cx - _pw2 / 2, _py2 = (GUI_H - _ph2) / 2;
    draw_panel(_px2, _py2, _pw2, _ph2);

    draw_set_font(fnt_math);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_colour(COL_WARN);
    draw_text_transformed(_cx, _py2 + 26, "Cómo jugar", 0.8, 0.8, 0);

    draw_set_font(fnt_ui);
    draw_set_halign(fa_left);
    draw_set_colour(COL_TEXT);
    var _hw = title_howto();
    var _hy = _py2 + 105;
    var _scale = 0.85;
    var _sep = string_height("M") + 4;
    for (var j = 0; j < array_length(_hw); j++) {
        draw_text_ext_transformed(_px2 + 40, _hy, _hw[j], _sep, (_pw2 - 80) / _scale, _scale, _scale, 0);
        _hy += string_height_ext(_hw[j], _sep, (_pw2 - 80) / _scale) * _scale + 8;
    }
    draw_set_halign(fa_center);
    draw_set_colour(COL_DIM);
    draw_text(_cx, _py2 + _ph2 - 50, "Enter o Esc: volver");
}

// Restaurar estado de dibujo
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
