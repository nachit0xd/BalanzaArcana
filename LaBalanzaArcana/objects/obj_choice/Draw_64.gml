if (closing) exit;

draw_set_alpha(0.55);
draw_set_colour(c_black);
draw_rectangle(0, 0, GUI_W, GUI_H, false);
draw_set_alpha(1);

draw_set_font(fnt_ui);
var _lh = string_height("M") + 10;
var _ph = string_height(prompt_wrap);
var _pw = 1000;
var _pn = _ph + 44 + array_length(options) * _lh + 70;
var _px = GUI_W / 2 - _pw / 2;
var _py = GUI_H / 2 - _pn / 2;

draw_panel(_px, _py, _pw, _pn);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(COL_TEXT);
draw_text(_px + 48, _py + 36, prompt_wrap);

for (var i = 0; i < array_length(options); i++) {
    var _on = (i == sel);
    draw_set_colour(_on ? COL_WARN : COL_TEXT);
    draw_text(_px + 96, _py + 36 + _ph + 28 + i * _lh, (_on ? ">  " : "    ") + options[i]);
}

draw_set_halign(fa_center);
draw_set_colour(COL_DIM);
draw_text(GUI_W / 2, _py + _pn - 40, "Arriba / abajo: elegir     |     Espacio o Enter: aceptar");

draw_set_halign(fa_left);
draw_set_colour(c_white);
