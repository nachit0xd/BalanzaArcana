// Tecla de acción: Espacio, Enter o E.
// Devuelve false mientras global.ui_cooldown > 0. Ese contador lo activa
// un diálogo al cerrarse, para que la misma pulsación que lo cerró no
// vuelva a abrir otro diálogo en el mismo instante.
function action_pressed() {
    if (global.ui_cooldown > 0) return false;
    return keyboard_check_pressed(vk_space)
        || keyboard_check_pressed(vk_enter)
        || keyboard_check_pressed(ord("E"));
}

function ui_block(_frames) {
    global.ui_cooldown = max(global.ui_cooldown, _frames);
}

// Una línea de diálogo con hablante propio: dlg("Maestro", "Hola")
function dlg(_who, _text) {
    return { who: _who, text: _text };
}

// Lanza un diálogo:
//   _lines   : array de strings (los dice _speaker) o de dlg(...)
//   _speaker : nombre por defecto que se muestra sobre la caja
//   _on_done : function() que se ejecuta al cerrar (puede ser undefined)
function dialogue_start(_lines, _speaker, _on_done) {
    if (dialogue_active()) return noone;
    var _d = instance_create_depth(0, 0, -900, obj_dialogue);
    _d.start(_lines, _speaker, _on_done);
    return _d;
}

// ¿Hay un diálogo abierto? (se ignora uno que ya está cerrándose, para
// poder encadenar un diálogo nuevo dentro del callback del anterior)
function dialogue_active() {
    var _active = false;
    with (obj_dialogue) {
        if (!closing) _active = true;
    }
    return _active;
}

// Parte un texto en renglones que caben en _max_w píxeles, usando la
// fuente actual (llama a draw_set_font antes). Así el efecto de escritura
// letra por letra no "salta" palabras de un renglón a otro.
function text_wrap(_str, _max_w) {
    var _out = "", _line = "", _word = "";
    var _n = string_length(_str);

    for (var i = 1; i <= _n + 1; i++) {
        var _ch = (i <= _n) ? string_char_at(_str, i) : " ";    // el último " " cierra la palabra final

        if (_ch == " " || _ch == "\n") {
            if (_word != "") {
                var _try = (_line == "") ? _word : _line + " " + _word;
                if (string_width(_try) > _max_w && _line != "") {
                    _out += _line + "\n";
                    _line = _word;
                } else {
                    _line = _try;
                }
                _word = "";
            }
            if (_ch == "\n") {
                _out += _line + "\n";
                _line = "";
            }
        } else {
            _word += _ch;
        }
    }
    return _out + _line;
}
