// Introducción del maestro al inicio del nivel (una sola vez por nivel)
if (intro_delay > 0) {
    intro_delay--;
} else if (intro_delay == 0 && !world_frozen() && global.ui_cooldown <= 0) {
    intro_delay = -1;                      // ya no se vuelve a intentar en esta room
    level_intro_start(global.level);
}

// Teclas del modo DEBUG
if (DEBUG_MODE) {
    if (keyboard_check_pressed(vk_f2)) room_goto(rm_title);
    if (keyboard_check_pressed(vk_f3)) { progress_reset(); level_checkpoint_save(1); room_goto(rm_village); }   // reinicia la partida de prueba

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
