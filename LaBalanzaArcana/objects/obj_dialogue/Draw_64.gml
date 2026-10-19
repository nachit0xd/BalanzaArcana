if (closing || array_length(lines) == 0) exit;

draw_set_font(fnt_ui);
draw_set_halign(fa_left);

// Color según quién habla: dorado = NPC, celeste = maestro, rojo = enemigo
var _acc = role_color(portrait_id);

// Retrato de quien habla: arriba a la derecha de la caja. En combate no se muestra
// porque la escena ya muestra al enemigo.
if (portrait_id != "" && !battle_active() && !boss_active()) {
    var _k   = min(pt / 12, 1);                       // entrada suave (0.2 s)
    var _prw = 224, _prh = 224;
	portrait_draw(portrait_id, box_x + box_w - _prw, box_y - _prh - 8, _prw, _prh, pt, _k, _acc);
}

// Caja
draw_set_colour(COL_PANEL);
draw_rectangle(box_x, box_y, box_x + box_w, box_y + box_h, false);
draw_set_colour(_acc);
draw_rectangle(box_x, box_y, box_x + box_w, box_y + box_h, true);
draw_rectangle(box_x + 2, box_y + 2, box_x + box_w - 2, box_y + box_h - 2, true);

// Etiqueta con el nombre de quien habla
if (cur_who != "") {
    var _tw = string_width(cur_who) + 48;
    var _ty = box_y - 44;
    draw_set_colour(COL_PANEL);
    draw_rectangle(box_x, _ty, box_x + _tw, box_y, false);
    draw_set_colour(_acc);
    draw_rectangle(box_x, _ty, box_x + _tw, box_y, true);
    draw_set_colour((portrait_id == "") ? COL_WARN : _acc);
    draw_set_valign(fa_middle);
    draw_text(box_x + 24, _ty + 22, cur_who);
}

// Texto (solo las letras ya escritas)
draw_set_valign(fa_top);
draw_set_colour(COL_TEXT);
draw_text(box_x + pad, box_y + pad, string_copy(text_full, 1, floor(chars)));

// Indicador parpadeante de "pulsa para continuar"
if (line_done && ((current_time div 400) mod 2 == 0)) {
    var _tx = box_x + box_w - 40;
    var _by = box_y + box_h - 36;
    draw_set_colour(COL_WARN);
    draw_triangle(_tx, _by, _tx + 20, _by, _tx + 10, _by + 14, false);
}

// Restaurar estado de dibujo
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);
