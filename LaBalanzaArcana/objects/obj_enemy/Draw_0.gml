// Pequeño vaivén al caminar
var _bob = (state == 1) ? sin(walk_t * 6) * 1.2 : 0;
draw_sprite(sprite_index, image_index, x, y + _bob);

// Flecha roja de aviso cuando el jugador está cerca
if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) < 70) {
    var _by = y - 21 + sin(current_time / 140) * 1.5;
    draw_set_colour(c_red);
    draw_triangle(x - 3, _by - 4, x + 3, _by - 4, x, _by, false);
    draw_set_colour(c_white);
}

