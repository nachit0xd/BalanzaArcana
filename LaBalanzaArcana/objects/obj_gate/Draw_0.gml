var _l = x + hb_l, _t = y + hb_t, _r = x + hb_r + 1, _b = y + hb_b + 1;
var _open = level_requirements_met(3);

// Hoja del portón
draw_set_colour(make_colour_rgb(34, 18, 52));
draw_rectangle(_l, _t, _r, _b, false);
draw_set_colour(make_colour_rgb(250, 205, 70));
draw_rectangle(_l, _t, _r - 1, _b - 1, true);
draw_rectangle(_l + 1, _t + 1, _r - 2, _b - 2, true);
draw_line((_l + _r) / 2, _t + 1, (_l + _r) / 2, _b - 1);        // juntura de las dos hojas

if (_open) {
    // Abierto: late un resplandor celeste
    var _pulse = 0.35 + 0.25 * sin(current_time / 300);
    draw_set_alpha(_pulse);
    draw_set_colour(c_aqua);
    draw_circle((_l + _r) / 2, (_t + _b) / 2, 11, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
    draw_circle((_l + _r) / 2, (_t + _b) / 2, 4, false);
} else {
    // Sellado: cadenas rojas cruzadas
    draw_set_colour(c_red);
    draw_line_width(_l + 2, _t + 2, _r - 2, _b - 2, 2);
    draw_line_width(_r - 2, _t + 2, _l + 2, _b - 2, 2);
}
draw_set_colour(c_white);

// Con F1 se ve la caja de colisión
if (global.debug) {
    draw_set_colour(c_fuchsia);
    draw_set_alpha(0.4);
    draw_rectangle(_l, _t, _r - 1, _b - 1, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}
