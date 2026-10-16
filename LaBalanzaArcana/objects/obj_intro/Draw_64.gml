var _sl = slides[min(idx, array_length(slides) - 1)];
var _cx = GUI_W / 2;

// Inclinación de la balanza pasa suavemente de "from" a "to" en 1,5 s
var _p    = clamp(st / 90, 0, 1);
var _ease = _p * _p * (3 - 2 * _p);
var _ang  = lerp(_sl.from, _sl.to, _ease) + 1.5 * dsin(total_t * 2);

draw_sky(clamp(abs(_ang) / 26, 0, 1));         // el cielo se tiñe de rojo al desequilibrarse
draw_stars(stars, total_t);

draw_balance(_cx, 170, _ang, 1.2);

// Texto de la historia (con sombra)
draw_set_font(fnt_ui);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
var _shown = string_copy(text_full, 1, floor(chars));
draw_text_shadow(_cx, 500, _shown, COL_TEXT);

// Indicador de lámina (puntos)
var _n = array_length(slides);
for (var i = 0; i < _n; i++) {
    draw_set_colour((i == idx) ? COL_WARN : COL_BORDER);
    draw_circle(_cx - (_n - 1) * 14 + i * 28, GUI_H - 56, 6, false);
}

// Ayuda
draw_set_halign(fa_right);
draw_set_colour(COL_DIM);
draw_text(GUI_W - 24, GUI_H - 44, (total_t > 60) ? "Enter: continuar     Esc: saltar" : "Enter: continuar");

// Restaurar estado de dibujo
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
draw_set_alpha(1);
