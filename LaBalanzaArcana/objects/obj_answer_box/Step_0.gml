if (!enabled) exit;

// Ignorar los primeros frames (evita que una tecla pulsada antes entre al campo)
if (grace > 0) {
    grace--;
    keyboard_string = "";
    exit;
}

// 1) Filtrar lo escrito y guardarlo en el campo con foco
var _clean = answer_sanitize(keyboard_string, max_len);
if (_clean != keyboard_string) keyboard_string = _clean;
var _prev_len = string_length(texts[focus]);
texts[focus] = _clean;
if (string_length(_clean) > _prev_len)      sfx_ext("snd_key", 0.6, random_range(0.95, 1.08));   // escribe
else if (string_length(_clean) < _prev_len) sfx_ext("snd_key", 0.5, 0.8);                         // borra

// 2) Tab: cambiar de campo (solo con 2 campos)
if (fields == 2 && keyboard_check_pressed(vk_tab)) {
    focus = 1 - focus;
    keyboard_string = texts[focus];
}

// 3) Enter: enviar si todo es válido; si no, llevar el foco al primer campo incompleto
if (keyboard_check_pressed(vk_enter)) {
    if (all_valid()) {
        submitted = true;
    } else {
        for (var i = 0; i < fields; i++) {
            if (!answer_is_valid(texts[i])) {
                focus = i;
                keyboard_string = texts[i];
                break;
            }
        }
        shake = 10;
    }
}

if (shake > 0) shake--;
