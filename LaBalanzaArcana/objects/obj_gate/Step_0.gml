can_talk = false;
if (!instance_exists(obj_player) || world_frozen()) exit;

var _p = obj_player;
if (point_distance(_p.x, _p.y, x + 8, y) <= 44 && _p.faces(x + 8, y)) {
    can_talk = true;
    if (action_pressed()) gate_interact();
}
