// Introducción del maestro al inicio del nivel (una sola vez por nivel)
if (intro_delay > 0) {
    intro_delay--;
} else if (intro_delay == 0 && !world_frozen() && global.ui_cooldown <= 0) {
    intro_delay = -1;                      // ya no se vuelve a intentar en esta room
    level_intro_start(global.level);
}

if (DEBUG_MODE) {
    if (keyboard_check_pressed(vk_f2)) room_goto(rm_title);
    if (keyboard_check_pressed(vk_f3)) { progress_reset(); room_restart(); }   // reinicia la partida de prueba

    // F6, F7 y F8: previsualizar la introducción de los niveles 2, 3 y 4
    if (keyboard_check_pressed(vk_f6)) level_intro_preview(2);
    if (keyboard_check_pressed(vk_f7)) level_intro_preview(3);
    if (keyboard_check_pressed(vk_f8)) level_intro_preview(4);
	
	// F9: perder 25 % de vida | F10: restaurar vida | F11: vista previa de resultados
    if (keyboard_check_pressed(vk_f9))  life_lose(25);
    if (keyboard_check_pressed(vk_f10)) life_reset();
    if (keyboard_check_pressed(vk_f11)) results_show(global.level, true);
	
	// F12: pasar al siguiente nivel (solo pruebas)
    if (keyboard_check_pressed(vk_f12)) level_goto(min(MAX_LEVEL, global.level + 1));
}

// Puente cerrado: si el jugador intenta cruzar, la guardiana se lo recuerda
if (bridge_msg_cd > 0) bridge_msg_cd--;
if (bridge_locked() && bridge_msg_cd <= 0 && !world_frozen() && instance_exists(obj_player)) {
    var _bp = obj_player;
    if (_bp.x >= 28 * TILE - 12 && _bp.y >= 11 * TILE && _bp.y <= 13 * TILE
        && (keyboard_check(vk_right) || keyboard_check(ord("D")))) {
        bridge_msg_cd = 600;
        dialogue_start([ "La guardiana te corta el paso: nadie cruza el puente sin ayudar con el registro.",
                         "Habla con ella primero." ], "", undefined);
    }
}