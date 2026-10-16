if (closing) exit;
if (grace > 0) { grace--; exit; }

var _dir = (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
         - (keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W")));
sel = (sel + _dir + array_length(rows)) mod array_length(rows);

var _lr = (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")))
        - (keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A")));
if (_lr != 0 && rows[sel].kind != "button") change(_lr);

if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    if (rows[sel].kind == "button") finish();
    else if (rows[sel].kind == "toggle") change(1);
}
if (keyboard_check_pressed(vk_escape)) finish();
