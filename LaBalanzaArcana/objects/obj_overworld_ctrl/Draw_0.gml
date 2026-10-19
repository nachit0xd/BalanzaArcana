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