draw_set_font(fnt_math);
draw_set_valign(fa_middle);

var _blink = ((current_time div 450) mod 2 == 0);

for (var i = 0; i < fields; i++) {
    var _fx     = gx + i * (label_w + box_w + gap);
    var _bx     = _fx + label_w;
    var _active = enabled && (i == focus);
    var _jit    = (shake > 0 && _active) ? choose(-5, 5) : 0;

	// Los glifos Unicode ₁ y ₂ no están en fnt_math, por lo que se dibuja cada subíndice con un dígito de tamaño reducido
    draw_set_colour(COL_TEXT);
    if (fields == 2) {
        draw_set_halign(fa_left);
        draw_text(_bx - 90, gy + box_h / 2, "x");
        draw_text_transformed(_bx - 58, gy + box_h / 2 + 14, string(i + 1), 0.42, 0.42, 0);
        draw_text(_bx - 42, gy + box_h / 2, "=");
    } else {
        draw_set_halign(fa_right);
        draw_text(_bx - 14, gy + box_h / 2, labels[i]);
    }

    // Caja
    draw_set_colour(COL_INPUT_BG);
    draw_rectangle(_bx + _jit, gy, _bx + box_w + _jit, gy + box_h, false);
    draw_set_colour(_active ? COL_WARN : COL_BORDER);
    draw_rectangle(_bx + _jit, gy, _bx + box_w + _jit, gy + box_h, true);
    draw_rectangle(_bx + 1 + _jit, gy + 1, _bx + box_w - 1 + _jit, gy + box_h - 1, true);

    // Texto escrito + cursor parpadeante
    draw_set_halign(fa_left);
    draw_set_colour(enabled ? COL_TEXT : COL_DIM);
    var _t = texts[i] + ((_active && _blink) ? "_" : "");
    draw_text(_bx + 18 + _jit, gy + box_h / 2, _t);
}

// Restaurar estado de dibujo
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);