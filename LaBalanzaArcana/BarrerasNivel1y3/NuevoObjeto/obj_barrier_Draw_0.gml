draw_self();

if (global.debug) {
    draw_set_colour(c_fuchsia);
    draw_set_alpha(0.4);
    draw_rectangle(x + hb_l, y + hb_t, x + hb_r, y + hb_b, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}
