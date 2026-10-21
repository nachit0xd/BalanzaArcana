t++;
tt++;

// Los símbolos flotantes suben
for (var i = 0; i < array_length(glyphs); i++) {
    glyphs[i].y -= glyphs[i].spd;
    if (glyphs[i].y < -30) glyphs[i] = new_glyph(false);
}

if (starting) exit;

if (options_active()) exit;
if (global.ui_cooldown > 0) exit;      // Evita que el Enter que cerró las opciones las vuelva a abrir

var _dir = (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
         - (keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W")));

switch (state) {

    case TITLE_STATE.SPLASH:
        // Pasa solo, o con cualquier tecla (tras un instante)
        if (t > 260 || (t > 20 && keyboard_check_pressed(vk_anykey))) { global.splash_done = true; set_state(TITLE_STATE.MENU); }
        break;

    case TITLE_STATE.MENU:
        sel = (sel + _dir + array_length(menu_items)) mod array_length(menu_items);
        if (accept_pressed()) {
            switch (sel) {
                case 0: set_state(TITLE_STATE.NOTICE);  break;
                case 1: set_state(TITLE_STATE.HOWTO);   break;
                case 2: options_show(undefined);        break;
                case 3: set_state(TITLE_STATE.CREDITS); break;
                case 4: game_end(); break;
            }
        }
        break;

    case TITLE_STATE.HOWTO:
    case TITLE_STATE.CREDITS:
        if (accept_pressed() || keyboard_check_pressed(vk_escape)) set_state(TITLE_STATE.MENU);
        break;

    case TITLE_STATE.NOTICE:
        if (keyboard_check_pressed(vk_escape)) {
            set_state(TITLE_STATE.MENU);
        } else if (accept_pressed()) {
            keyboard_string = "";
            code_text  = "";
            code_error = "";
            set_state(TITLE_STATE.CODE);
        }
        break;

    case TITLE_STATE.CODE:
        // Filtra lo escrito, como mayúsculas, solo A-Z y 0-9, máximo 6 caracteres
        var _c = code_sanitize(keyboard_string);
        if (_c != keyboard_string) keyboard_string = _c;
        if (_c != code_text) code_error = "";
        code_text = _c;

        if (keyboard_check_pressed(vk_escape)) {
            set_state(TITLE_STATE.NOTICE);
        } else if (keyboard_check_pressed(vk_enter)) {
            if (code_is_valid(code_text)) {
                confirm_sel = 0;
                set_state(TITLE_STATE.CONFIRM);
            } else {
                code_error = code_error_text(code_text);
            }
        }
        break;

    case TITLE_STATE.CONFIRM:
        if (keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"))) confirm_sel = 0;
        if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) confirm_sel = 1;

        if (keyboard_check_pressed(vk_escape)) {
            keyboard_string = code_text;
            set_state(TITLE_STATE.CODE);
        } else if (accept_pressed()) {
            if (confirm_sel == 0) {
                // Código confirmado, se abre la sesión y se pasa a la cinemática
                session_start(code_text);
                room_transition(rm_intro);
                starting = true;
            } else {
                keyboard_string = code_text;           // Volver a editar
                set_state(TITLE_STATE.CODE);
            }
        }
        break;
}
