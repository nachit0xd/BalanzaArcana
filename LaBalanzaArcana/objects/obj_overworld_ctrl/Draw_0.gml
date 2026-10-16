// Barrera del puente (aldea): visible mientras la misión de la guardiana no esté cumplida
if (bridge_locked()) {
    var _bx = 28 * TILE - 6, _by = 11 * TILE;     // justo antes de la entrada oeste del puente
    var _bh = 2 * TILE;                           // el puente mide 2 casillas de alto
    draw_set_colour(make_colour_rgb(120, 70, 40));
    draw_rectangle(_bx, _by - 3, _bx + 4, _by + 1, false);                  // poste superior
    draw_rectangle(_bx, _by + _bh - 1, _bx + 4, _by + _bh + 3, false);     // poste inferior
    for (var j = 0; j < _bh / 4; j++) {                                    // barra a rayas
        draw_set_colour((j mod 2 == 0) ? c_red : c_white);
        draw_rectangle(_bx + 1, _by + j * 4, _bx + 3, _by + j * 4 + 3, false);
    }
    draw_set_colour(c_white);
}

// Con F1 dibuja los marcadores (aparición, NPC, enemigos, salidas)
if (!global.debug) exit;

var _names = variable_struct_get_names(global.markers);
draw_set_colour(c_yellow);
for (var i = 0; i < array_length(_names); i++) {
    var _m = global.markers[$ _names[i]];
    draw_circle(_m.x, _m.y, 2, false);
    draw_text_transformed(_m.x + 4, _m.y - 12, _names[i], 0.5, 0.5, 0);
}
draw_set_colour(c_white);