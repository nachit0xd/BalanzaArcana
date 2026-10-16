switch (stage) {

    case 0:
        if (intro_delay > 0) {
            intro_delay--;
        } else if (!ui_modal_active() && global.ui_cooldown <= 0) {
            level_intro_start(global.level);   // el maestro explica las ecuaciones con x²
            stage = 1;
        }
        break;

    case 1:
        // Cuando el maestro termina (o si no había introducción), empieza el combate
        if (!ui_modal_active()) {
            boss_begin();
            stage = 2;
        }
        break;
}

// Atajo de desarrollo: Esc vuelve a rm_title
if (DEBUG_MODE && keyboard_check_pressed(vk_f2)) room_goto(rm_title);

