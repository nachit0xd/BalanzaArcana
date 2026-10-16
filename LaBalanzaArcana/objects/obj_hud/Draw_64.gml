draw_set_font(fnt_ui);
var _lh = string_height("M") + 4;

// Placa izquierda: vida
var _n   = hud_segments();
var _lf  = hud_left();
var _px  = 16, _py = 16;
var _barx = _px + 56, _barw = 268, _barh = 26;
var _pw  = 56 + _barw + 18, _ph = 56;
draw_plaque(_px, _py, _pw, _ph);

var _col = (_lf >= _n) ? COL_GOOD : ((_lf <= 1) ? COL_BAD : COL_WARN);
draw_heart(_px + 28, _py + 26, 11, (_lf > 0) ? COL_BAD : COL_DIM);

var _gap = 8;
var _sw  = (_barw - (_n - 1) * _gap) / _n;
for (var i = 0; i < _n; i++) {
    var _sx = _barx + i * (_sw + _gap);
    var _sy = _py + (_ph - _barh) / 2;
    draw_set_colour(COL_INPUT_BG);
    draw_rectangle(_sx, _sy, _sx + _sw, _sy + _barh, false);
    if (i < _lf) {
        draw_set_colour(_col);
        draw_rectangle(_sx + 3, _sy + 3, _sx + _sw - 3, _sy + _barh - 3, false);
    } else if (i == blink_idx && blink_t > 0 && ((blink_t div 5) mod 2 == 0)) {
        draw_set_colour(COL_BAD);                       // el segmento recién perdido destella
        draw_rectangle(_sx + 3, _sy + 3, _sx + _sw - 3, _sy + _barh - 3, false);
    }
    draw_set_colour(COL_BORDER);
    draw_rectangle(_sx, _sy, _sx + _sw, _sy + _barh, true);
}

// Placa derecha: puntaje y nivel
var _l1 = "Puntaje: " + string(shown_score);
var _l2 = "Nivel " + string(global.level) + ": " + level_name(global.level);
var _w2 = max(string_width(_l1), string_width(_l2)) + 76;
var _h2 = _lh * 2 + 20;
var _x2 = GUI_W - 16 - _w2, _y2 = 16;
draw_plaque(_x2, _y2, _w2, _h2);

draw_star(_x2 + 28, _y2 + 10 + _lh / 2, 12, COL_WARN);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(COL_TEXT);
draw_text(_x2 + 56, _y2 + 8, _l1);
draw_set_colour(make_colour_rgb(225, 220, 245));          // claro: se lee sobre cualquier mapa
draw_text(_x2 + 56, _y2 + 8 + _lh, _l2);

// "+N" que sube bajo la placa derecha
draw_set_halign(fa_right);
for (var j = 0; j < array_length(popups); j++) {
    var _pp = popups[j];
    draw_set_alpha(clamp(1 - _pp.t / 55, 0, 1));
    draw_set_colour(c_black);
    draw_text(GUI_W - 24 + 2, _y2 + _h2 + 12 + _pp.t * 0.7 + 2, _pp.txt);
    draw_set_colour(COL_GOOD);
    draw_text(GUI_W - 24, _y2 + _h2 + 12 + _pp.t * 0.7, _pp.txt);
}

// Restaurar estado de dibujo
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
