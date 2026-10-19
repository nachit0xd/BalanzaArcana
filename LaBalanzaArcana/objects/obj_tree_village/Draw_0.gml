draw_self();

if (global.debug) {
    draw_set_colour(c_lime);
    draw_set_alpha(0.7);
    draw_rectangle(x + trunk_left, y + trunk_top,
                   x + trunk_right, y + trunk_bottom, true);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}