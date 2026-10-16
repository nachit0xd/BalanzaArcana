if (closing || array_length(lines) == 0) exit;

pt++;
if (grace > 0) { grace--; exit; }

// Escribir letra por letra
if (!line_done) {
    var _before = floor(chars);
    chars += cps;
    if (chars >= string_length(text_full)) {
        chars = string_length(text_full);
        line_done = true;
    }
    // Un "blip" cada 2 letras (no en espacios); el tono depende de quién habla
    var _now = floor(chars);
    if (_now > _before && (_now mod 2) == 0) {
        var _ch = string_char_at(text_full, _now);
        if (_ch != " " && _ch != "\n") sfx_ext("snd_blip", 0.55, voice_pitch(portrait_id) * random_range(0.95, 1.08));
    }
}

// Tecla de acción: si aún escribe, completa la línea; si no, pasa a la siguiente
if (action_pressed()) {
    if (!line_done) {
        chars = string_length(text_full);
        line_done = true;
    } else {
        advance();
    }
}
