if (!bridge_locked()) exit;

draw_set_colour(make_colour_rgb(120, 70, 40));
draw_rectangle(x, y - 3, x + 4, y + 1, false);
draw_rectangle(x, y + span_px - 1, x + 4, y + span_px + 3, false);
for (var j = 0; j < span_px / 4; j++) {
    draw_set_colour((j mod 2 == 0) ? c_red : c_white);
    draw_rectangle(x + 1, y + j * 4, x + 3, y + j * 4 + 3, false);
}
draw_set_colour(c_white);
