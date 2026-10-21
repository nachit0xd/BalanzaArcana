draw_self();

// Flecha que flota sobre el NPC cuando se puede hablar con él
if (can_talk) {
    var _by = y - 21 + sin(current_time / 180) * 1.5;
    draw_set_colour(c_yellow);
    draw_triangle(x - 3, _by - 4, x + 3, _by - 4, x, _by, false);
    draw_set_colour(c_white);
}

