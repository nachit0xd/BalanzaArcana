if (closing || is_undefined(stats)) exit;

var _px = 64, _py = 24, _pw = GUI_W - 128, _ph = GUI_H - 48;
var _cx = GUI_W / 2;

// Fondo y panel
draw_set_alpha(0.8);
draw_set_colour(c_black);
draw_rectangle(0, 0, GUI_W, GUI_H, false);
draw_set_alpha(1);
draw_set_colour(COL_PANEL);
draw_rectangle(_px, _py, _px + _pw, _py + _ph, false);
draw_set_colour(COL_BORDER);
draw_rectangle(_px, _py, _px + _pw, _py + _ph, true);
draw_rectangle(_px + 2, _py + 2, _px + _pw - 2, _py + _ph - 2, true);

draw_set_font(fnt_ui);
var _lh = string_height("M") + 10;
draw_set_font(fnt_math);
var _th = string_height("M");

// Título
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_colour(COL_WARN);
draw_text(_cx, _py + 20, "¡Nivel " + string(level_id) + " completado!");
draw_set_font(fnt_ui);
draw_set_colour(COL_DIM);
draw_text(_cx, _py + 20 + _th + 4, level_name(level_id));

var _y1 = _py + 20 + _th + 4 + _lh + 24;      // donde empiezan las columnas
draw_set_halign(fa_left);

if (page == 1) {

    // Columna izquierda: resumen
    var _lx = _px + 48, _rx = _px + 540;
    if (t >= 10) {
        draw_set_colour(COL_WARN);
        draw_text(_lx, _y1, "Resumen");

        var _lab = [
            "Puntaje del nivel",
            "Puntaje acumulado",
            "Resueltos al 1.er intento",
            "Resueltos al 2.º intento",
            "Sin resolver",
            "Vida perdida"
        ];
        var _val = [
            string(shown_pts),
            string(shown_total),
            string(stats.first),
            string(stats.second),
            string(stats.failed),
            string(round(stats.life_lost)) + " %"
        ];
        for (var i = 0; i < array_length(_lab); i++) {
            var _yy = _y1 + _lh * (i + 1);
            draw_set_halign(fa_left);
            draw_set_colour(COL_TEXT);
            draw_text(_lx, _yy, _lab[i]);
            draw_set_halign(fa_right);
            draw_set_colour((i < 2) ? COL_GOOD : COL_TEXT);
            draw_text(_rx, _yy, _val[i]);
        }
    }

    //  Columna derecha: por personaje
    if (t >= 45) {
        var _nx = _px + 580;
        var _r3 = _px + _pw - 48, _r2 = _r3 - 105, _r1 = _r3 - 190;

        draw_set_halign(fa_left);
        draw_set_colour(COL_WARN);
        draw_text(_nx, _y1, "Por personaje");
        draw_set_halign(fa_right);
        draw_set_colour(COL_DIM);
        draw_text(_r1, _y1, "1.º");
        draw_text(_r2, _y1, "2.º");
        draw_text(_r3, _y1, "Fallos");

        for (var k = 0; k < array_length(rows); k++) {
            var _ry = _y1 + _lh * (k + 1);
            draw_set_halign(fa_left);
            draw_set_colour(COL_TEXT);
            draw_text(_nx, _ry, rows[k].name);
            draw_set_halign(fa_right);
            draw_set_colour(COL_GOOD);
            draw_text(_r1, _ry, string(rows[k].first));
            draw_text(_r2, _ry, string(rows[k].second));
            draw_set_colour((rows[k].failed > 0) ? COL_BAD : COL_DIM);
            draw_text(_r3, _ry, string(rows[k].failed));
        }
    }

    // Insignias nuevas (resumen)
    if (t >= 80) {
        draw_set_halign(fa_left);
        draw_set_colour(COL_WARN);
        var _bt = (array_length(new_badges) > 0)
                ? "Insignias nuevas: " + string(array_length(new_badges)) + "  (se muestran en la siguiente pantalla)"
                : "Ninguna insignia nueva en este nivel.";
        draw_text(_px + 48, _py + _ph - 2 * _lh - 24, _bt);
        draw_set_colour(COL_DIM);
        draw_text(_px + 48, _py + _ph - _lh - 24, "Insignias obtenidas en total: " + string(owned_total) + " de " + string(array_length(global.badge_defs)));
    }

} else {

    // Página 2: insignias nuevas
    draw_set_halign(fa_left);
    draw_set_colour(COL_WARN);
    draw_text(_px + 48, _y1, "Insignias obtenidas");
    draw_set_halign(fa_right);
    draw_set_colour(COL_DIM);
    draw_text(_px + _pw - 48, _y1, string(owned_total) + " de " + string(array_length(global.badge_defs)));

    var _n    = min(array_length(new_badges), 5);
    var _by   = _y1 + _lh + 16;
    for (var b = 0; b < _n; b++) {
        if (t < 15 + 20 * b) continue;                 // van apareciendo una a una
        var _bd = new_badges[b];

        // Medallón dorado
        draw_set_colour(c_yellow);
        draw_circle(_px + 70, _by + _lh / 2, 14, false);
        draw_set_colour(COL_PANEL);
        draw_circle(_px + 70, _by + _lh / 2, 6, false);

        draw_set_halign(fa_left);
        draw_set_colour(COL_TEXT);
        draw_text(_px + 110, _by, _bd.name);
        draw_set_colour(COL_DIM);
        draw_text_ext(_px + 110, _by + _lh, _bd.desc, _lh - 6, _pw - 220);

        _by += _lh * 2 + 24 + ((string_width(_bd.desc) > _pw - 220) ? _lh : 0);
    }
    if (array_length(new_badges) > 5) {
        draw_set_colour(COL_DIM);
        draw_text(_px + 110, _by, "... y " + string(array_length(new_badges) - 5) + " más");
    }
}

// Pie
if (page_ready()) {
    if ((current_time div 500) mod 2 == 0) {
        draw_set_halign(fa_center);
        draw_set_colour(COL_DIM);
        draw_text(_cx, _py + _ph - 44, (page < pages) ? "Enter: ver insignias" : "Enter: continuar");
    }
}

// Etiqueta de vista previa (solo pruebas)
if (preview) {
    draw_set_halign(fa_left);
    draw_set_colour(COL_BAD);
    draw_text(_px + 24, _py + 12, "VISTA PREVIA");
}

// Restaurar estado de dibujo
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_set_alpha(1);
