draw_self();

// Flecha que flota sobre el NPC cuando se puede hablar con él
if (can_talk) {
    var _by = y - 21 + sin(current_time / 180) * 1.5;
    draw_set_colour(c_yellow);
    draw_triangle(x - 3, _by - 4, x + 3, _by - 4, x, _by, false);
    draw_set_colour(c_white);
}

// Con F1 se ve la caja de colisión (azul)
if (global.debug) {
    draw_set_colour(c_aqua);
    draw_set_alpha(0.5);
    draw_rectangle(x + hb_l, y + hb_t, x + hb_r, y + hb_b, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}
