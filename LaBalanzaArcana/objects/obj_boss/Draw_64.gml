if (closing) exit;

var _a  = anim_in;
var _cx = GUI_W / 2;

// Escena (franja superior, 0..300)
draw_set_alpha(_a);
var _c1 = make_colour_rgb(30, 10, 36);
var _c2 = make_colour_rgb(86, 26, 48);
draw_rectangle_colour(0, 0, GUI_W, 300, _c1, _c1, _c2, _c2, false);
draw_set_colour(make_colour_rgb(38, 20, 40));
draw_rectangle(0, 262, GUI_W, 300, false);

// Zona inferior oscurecida (ahí aparece el panel del ejercicio)
draw_set_colour(c_black);
draw_set_alpha(0.82 * _a);
draw_rectangle(0, 300, GUI_W, GUI_H, false);
draw_set_alpha(_a);

// Jefe (sprite de 32 px ampliado ×5) y jugador (16 px ×8)
var _bx = boss_x   + ((shake_e > 0) ? choose(-6, 6) : 0);
var _px = player_x + ((shake_p > 0) ? choose(-6, 6) : 0);
var _bc = (shake_e > 0 && (shake_e mod 4) < 2) ? c_red : c_white;
var _pc = (shake_p > 0 && (shake_p mod 4) < 2) ? c_red : c_white;
draw_sprite_ext(spr_boss,   0, _bx, boss_y,   5, 5, 0, _bc, _a);
draw_sprite_ext(spr_player, 0, _px, player_y, 8, 8, 0, _pc, _a);

// Escudo
var _sx = boss_x, _sy = boss_y - 80, _sr = 105;
if (shatter_t > 0) {
    // Se rompe: anillos que se expanden y se desvanecen
    var _k = 1 - shatter_t / 60;
    draw_set_alpha((1 - _k) * _a);
    draw_set_colour(c_aqua);
    draw_circle(_sx, _sy, _sr + _k * 90, true);
    draw_circle(_sx, _sy, _sr + _k * 60, true);
}
if (shield_a > 0) {
    var _flick = (crack_t > 0) ? (0.5 + 0.5 * dsin(crack_t * 40)) : 1;
    draw_set_colour(c_aqua);
    draw_set_alpha(0.22 * shield_a * _flick * _a);
    draw_circle(_sx, _sy, _sr, false);
    draw_set_alpha(0.9 * shield_a * _flick * _a);
    draw_circle(_sx, _sy, _sr, true);
    draw_circle(_sx, _sy, _sr - 1, true);
    if (crack_t > 0) {                          // grietas blancas desde el centro
        draw_set_colour(c_white);
        draw_set_alpha(_a);
        for (var i = 0; i < array_length(crack_ang); i++) {
            draw_line_width(_sx, _sy,
                            _sx + lengthdir_x(crack_len[i], crack_ang[i]),
                            _sy + lengthdir_y(crack_len[i], crack_ang[i]), 2);
        }
    }
}
draw_set_alpha(_a);

// Nombre y sellos
draw_set_font(fnt_ui);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text_shadow(_cx - 50, 132, src.name, COL_TEXT);

// Etapa 2: puntos de energía del jefe
if (stage == 2) {
    var _hsep = 36;
    var _hx0  = _cx - 50 - (hp_max - 1) * _hsep / 2;
    for (var h = 0; h < hp_max; h++) {
        var _hx = _hx0 + h * _hsep;
        draw_set_colour((h < hp) ? COL_BAD : COL_INPUT_BG);
        draw_circle(_hx, 194, 12, false);
        draw_set_colour(COL_BORDER);
        draw_circle(_hx, 194, 12, true);
    }
}

// Tres sellos en columna a la derecha: rotos = apagados con una cruz
var _sx0 = GUI_W - 220;
draw_set_halign(fa_center);
draw_text_shadow(_sx0 + 60, 140, "Sellos", COL_DIM);
for (var s = 0; s < seals_max; s++) {
    var _sx = _sx0 + s * 60;
    var _yy = 218;
    if (s < broken) {
        draw_set_colour(COL_INPUT_BG);
        draw_circle(_sx, _yy, 20, false);
        draw_set_colour(COL_DIM);
        draw_circle(_sx, _yy, 20, true);
        draw_line_width(_sx - 10, _yy - 10, _sx + 10, _yy + 10, 3);
        draw_line_width(_sx + 10, _yy - 10, _sx - 10, _yy + 10, 3);
    } else {
        var _glow = (s == broken) ? (0.6 + 0.4 * dsin(current_time / 4)) : 1;
        draw_set_colour(COL_BAD);
        draw_set_alpha(_a * _glow);
        draw_circle(_sx, _yy, 20, false);
        draw_set_alpha(_a);
        draw_set_colour(COL_WARN);
        draw_circle(_sx, _yy, 20, true);
        draw_circle(_sx, _yy, 8, true);
    }
}

// Textos flotantes
draw_set_font(fnt_math);
for (var j = 0; j < array_length(pop); j++) {
    var _pp = pop[j];
    draw_set_alpha(clamp(1 - _pp.t / 50, 0, 1) * _a);
    draw_text_shadow(_pp.x, _pp.y - _pp.t * 0.8, _pp.txt, _pp.col);
}
draw_set_alpha(1);

// Letrero grande (Victoria / Has caído)
if (banner != "") {
    draw_set_font(fnt_math);
    draw_set_halign(fa_center);
    draw_set_colour(c_black);
    draw_text_transformed(_cx + 4, 104, banner, 2, 2, 0);
    draw_set_colour((state == "win_banner" || state == "win_dialogue") ? COL_GOOD : ((state == "shield_banner") ? COL_WARN : COL_BAD));
    draw_text_transformed(_cx, 100, banner, 2, 2, 0);
}

// Restaurar estado de dibujo
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_set_alpha(1);
