if (global.debug) {
    draw_set_color(c_lime);
    draw_text(8, 8, "FPS: " + string(fps) + "  |  " + room_get_name(room));
    draw_set_color(c_white);
}