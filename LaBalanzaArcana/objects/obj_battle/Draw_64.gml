if (closing) exit;

var _a  = anim_in;
var _cx = GUI_W / 2;

// Escena 
draw_set_alpha(_a);
var _c1 = make_colour_rgb(18, 24, 44);
var _c2 = make_colour_rgb(46, 80, 70);
draw_rectangle_colour(0, 0, GUI_W, 300, _c1, _c1, _c2, _c2, false);
draw_set_colour(make_colour_rgb(34, 58, 44));
draw_rectangle(0, 262, GUI_W, 300, false);

// Zona inferior oscurecida (panel del ejercicio)
draw_set_colour(c_black);
draw_set_alpha(0.82 * _a);
draw_rectangle(0, 300, GUI_W, GUI_H, false);
draw_set_alpha(_a);

// Enemigo y jugador (sprites de 16 px ampliados). Se tiñen de color rojo al recibir daño
var _ex = enemy_x  + ((shake_e > 0) ? choose(-6, 6) : 0);
var _px = player_x + ((shake_p > 0) ? choose(-6, 6) : 0);
var _ec = (shake_e > 0 && (shake_e mod 4) < 2) ? c_red : c_white;
var _pc = (shake_p > 0 && (shake_p mod 4) < 2) ? c_red : c_white;
draw_sprite_ext(spr_enemy,  look, _ex, enemy_y,  8, 8, 0, _ec, _a);
draw_sprite_ext(spr_player, 0,    _px, player_y, 8, 8, 0, _pc, _a);

// Nombre del enemigo y sus puntos de energía
draw_set_font(fnt_ui);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text_shadow(_cx + 10, 128, src.name, COL_TEXT);

var _sep = 36;
var _x0  = _cx + 10 - (hp_max - 1) * _sep / 2;
for (var i = 0; i < hp_max; i++) {
    var _pxx = _x0 + i * _sep;
    draw_set_colour((i < hp) ? COL_BAD : COL_INPUT_BG);
    draw_circle(_pxx, 194, 12, false);
    draw_set_colour(COL_BORDER);
    draw_circle(_pxx, 194, 12, true);
}

// Textos flotantes de daño
draw_set_font(fnt_math);
for (var j = 0; j < array_length(pop); j++) {
    var _pp = pop[j];
    draw_set_alpha(clamp(1 - _pp.t / 50, 0, 1) * _a);
    draw_text_shadow(_pp.x, _pp.y - _pp.t * 0.8, _pp.txt, _pp.col);
}
draw_set_alpha(1);

// Banner grande (Victoria o Has caído)
if (banner != "") {
    draw_set_font(fnt_math);
    draw_set_colour(c_black);
    draw_text_transformed(_cx + 4, 104, banner, 2, 2, 0);
    draw_set_colour((state == "win_banner" || state == "win_dialogue") ? COL_GOOD : COL_BAD);
    draw_text_transformed(_cx, 100, banner, 2, 2, 0);
}

// Restaurar estado de dibujo
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_set_alpha(1);
