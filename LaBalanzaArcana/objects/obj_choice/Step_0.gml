if (closing) exit;
if (grace > 0) { grace--; exit; }

var _dir = (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
         - (keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W")));
var _n = array_length(options);
sel = (sel + _dir + _n) mod _n;

if (action_pressed()) {
    closing = true;
    ui_block(10);
    var _cb = on_choose;
    var _i  = sel;
    instance_destroy();
    if (!is_undefined(_cb)) _cb(_i);
}