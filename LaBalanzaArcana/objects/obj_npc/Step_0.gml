can_talk = false;
if (npc_id == "" || !instance_exists(obj_player) || world_frozen()) exit;

// Debe estar cerca y el jugador debe mirarlo
if (point_distance(obj_player.x, obj_player.y, x, y) <= talk_range
    && obj_player.faces(x, y - 6)) {
    can_talk = true;
    if (action_pressed()) mission_begin(npc_id);
}
