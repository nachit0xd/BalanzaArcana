total_t++;
if (ending) exit;
st++;

var _s = slides[idx];

if (!typed_done) {
    chars += 0.8;
    if (chars >= string_length(text_full)) {
        chars = string_length(text_full);
        typed_done = true;
    }
} else {
    ht++;
    if (ht > _s.hold) next_slide();
}

// Enter / Espacio que completa el texto o pasa a la siguiente lámina
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    if (!typed_done) {
        chars = string_length(text_full);
        typed_done = true;
    } else {
        next_slide();
    }
}

// Esc para saltar toda la cinemática (con un breve margen para no saltarla sin querer)
if (total_t > 60 && keyboard_check_pressed(vk_escape)) finish();
