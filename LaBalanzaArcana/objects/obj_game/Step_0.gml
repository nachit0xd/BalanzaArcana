if (DEBUG_MODE && keyboard_check_pressed(vk_f1)) global.debug = !global.debug;

if (global.ui_cooldown > 0) global.ui_cooldown--;

log_upload_pump();

// Pausa: Esc, o automática si la ventana pierde el foco (solo durante la exploración)
if (pause_allowed() && (keyboard_check_pressed(vk_escape) || !window_has_focus())) pause_show();

// Tamaño de la ventana: se aplica unos frames después de un cambio
if (global.win_apply_t > 0) {
    global.win_apply_t--;
    if (global.win_apply_t == 0) window_apply_size();
}

// Música y sonidos de menús
audio_update();
if (menu_context_active()) {
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_down) || keyboard_check_pressed(vk_left)
        || keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("W")) || keyboard_check_pressed(ord("S"))) sfx("snd_ui_move");
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) sfx("snd_ui_select");
    if (keyboard_check_pressed(vk_escape)) sfx("snd_ui_back");
}