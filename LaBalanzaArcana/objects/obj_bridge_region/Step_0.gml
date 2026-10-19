if (notice_cd > 0) notice_cd--;
if (!bridge_locked() || notice_cd > 0 || world_frozen() || !instance_exists(obj_player)) exit;

var _p = obj_player;
var _right = keyboard_check(vk_right) || keyboard_check(ord("D"));
if (_right && _p.x >= x - notice_margin && _p.x <= x + 2
    && _p.y >= y && _p.y <= y + span_px) {
    notice_cd = 600;
    dialogue_start([
        "La guardiana te corta el paso: nadie cruza el puente sin ayudar con el registro.",
        "Habla con ella primero."
    ], "", undefined);
}
