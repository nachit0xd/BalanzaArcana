if (closing) exit;

// Mientras hay otro menú encima (opciones o confirmación), este no responde
if (options_active() || choice_active()) exit;
if (global.ui_cooldown > 0) exit;  // el Enter que cerró Opciones no debe abrirlo otra vez
if (grace > 0) { grace--; exit; }

var _accept = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);

if (mode == "howto") {
    if (_accept || keyboard_check_pressed(vk_escape)) mode = "main";
    exit;
}

var _dir = (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
         - (keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W")));
sel = (sel + _dir + array_length(items)) mod array_length(items);

if (keyboard_check_pressed(vk_escape)) {
    resume();
} else if (_accept) {
    switch (sel) {
        case 0: resume(); break;
        case 1: options_show(undefined); break;
        case 2: mode = "howto"; break;
        case 3:
            choice_show("¿Volver al menú principal? Se cerrará esta sesión de juego.",
                        [ "Sí, volver al menú", "No, seguir jugando" ],
                        pause_exit_chosen);
            break;
    }
}
