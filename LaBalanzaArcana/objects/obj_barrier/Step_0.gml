var _open = barrier_open(barrier_kind);
image_index = _open ? 1 : 0;
can_talk = false;
if (notice_cd > 0) notice_cd--;

if (!instance_exists(obj_player) || world_frozen()) exit;
var _p = obj_player;

if (barrier_kind == "gate") {
    // El portón del castillo usa la interacción de gate_interact()
    if (point_distance(_p.x, _p.y, x + 8, y) <= 44 && _p.faces(x + 8, y)) {
        can_talk = true;
        if (action_pressed()) gate_interact();
    }
} else if (barrier_kind == "bridge" && !_open && notice_cd <= 0) {
    // Aviso al intentar cruzar hacia la derecha, igual que obj_bridge_region
    var _right = keyboard_check(vk_right) || keyboard_check(ord("D"));
    if (_right && _p.x >= x - notice_margin && _p.x <= x + 2
        && _p.y >= y && _p.y <= y + span_px) {
        notice_cd = 600;
        dialogue_start([
            "La guardiana te corta el paso: nadie cruza el puente sin ayudar con el registro.",
            "Habla con ella primero."
        ], "", undefined);
    }
}
