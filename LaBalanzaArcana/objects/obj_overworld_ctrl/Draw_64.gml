// Con F1 muestra posición, casilla y dirección del jugador
if (!global.debug || !instance_exists(obj_player)) exit;

draw_set_font(fnt_ui);
draw_set_colour(c_lime);
draw_text(8, 40, "pos: " + string(obj_player.x) + ", " + string(obj_player.y)
               + "   casilla: " + string(obj_player.x div TILE) + ", " + string(obj_player.y div TILE)
               + "   dir: " + string(obj_player.dir));
draw_set_colour(c_white);