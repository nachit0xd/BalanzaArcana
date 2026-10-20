draw_self();

// Con la tecla F1 se ve la caja de colisión (rojo)
if (global.debug) {
    draw_set_colour(c_red);
    draw_set_alpha(0.6);
    draw_rectangle(x + hb_l, y + hb_t, x + hb_r, y + hb_b, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}
